//
//  ClientsViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/17/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Hero
import CoreStore
import Foundation
import SVProgressHUD
import DZNEmptyDataSet
import EZSwiftExtensions

protocol ClientsViewControllerDelegate {
    func switchTo(_ tabTitle: TabTitles)
}

class ClientsViewController: UIViewController, ListSectionObserver, LargeNavigationControllerProtocol {
    
    /// Delegate
    var delegate: LargeNavigationControllerDelegate?

    /// Navigation extension
    lazy var navigationExtension: ExtendedNavBarView = self.generateNavigationView(title: "Clients", image: #imageLiteral(resourceName: "client_add_icon"))
    
    /// List monitor
    lazy var studentsMonitor: ListMonitor<Student> = {
       return self.generateMonitor()
    }()
    
    /// Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Collection view
    lazy var collectionView: UICollectionView = {
       
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        
        /// Cells
        collectionView.register(ClientsCollectionViewCell.self, forCellWithReuseIdentifier: "\(ClientsCollectionViewCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Analytics
        Analytics.screen(screenId: .s5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Fetch data
        fetchStudents()
        
        /// Permissions check
        let config = Config.shared
        guard let permissions = config.permissions else {
            return
        }
        
        /// Update UI based on permissoins
        navigationExtension.isRightButtonEnabled = permissions.studentAdd?.isEnabled ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Setup
        customInit()
    }
    
    /// Custom setup
    private func customInit() {
     
        /// Add observer
        studentsMonitor.addObserver(self)
        
        /// Collection
        view.addSubview(collectionView)
        
        /// Delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Empty source delegate
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        /// Register cells
        collectionView.register(ClientsCollectionViewCell.self, forCellWithReuseIdentifier: "\(ClientsCollectionViewCell.self)")
        
        /// Navigation bar
        view.addSubview(navigationExtension)
        
        /// Collection layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(167)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
        
        /// Layout - navigation extension view
        navigationExtension.snp.updateConstraints { maker-> Void in
            maker.top.equalTo(view)
            maker.left.equalTo(view)
            maker.height.equalTo(167)
            maker.right.equalTo(view)
        }
    }
    
    /// Fetching students from server
    private func fetchStudents() {
        
        /// Fetch
        StudentAdapter.fetchList().catch { error in
            print(error)
        }
    }
    
    // MARK: ListObjectObserver
    func listMonitorDidChange(_ monitor: ListMonitor<Student>) {
        collectionView.reloadData()
    }
    
    func listMonitorDidRefetch(_ monitor: ListMonitor<Student>) {
        collectionView.reloadData()
    }
    
    // MARK: - Utilities
    func generateMonitor()-> ListMonitor<Student> {
        
        return DatabaseManager.defaultStack.monitorList(From<Student>(),
                                                        OrderBy(.ascending(StudentAttributes.fullName.rawValue)))
    }
    
    /// Search handler
    ///
    /// - Parameter text: search name
    func searchTextChanged(_ text: String) {
        
        if text.length > 0 {
            
            let fullNameParams = "\(StudentAttributes.fullName.rawValue)"
            studentsMonitor.refetch(Where("\(fullNameParams) CONTAINS[c] %@", text), OrderBy(.ascending(StudentAttributes.fullName.rawValue)))
            
            return
        }
        
        /// Reset monitor
        studentsMonitor = generateMonitor()
        studentsMonitor.addObserver(self)
        collectionView.reloadData()
        
        /// Analytics
        Analytics.trackEventWithID(.s5_1, eventParams: ["text": text])
    }
    
    /// Clear button
    func onClearButton() {
        self.searchTextChanged("")
        self.view.endEditing(true)
    }
    
    /// Trigger kickoff
    func onAddButton() {
        
        /// Add transition
        let createVC = ClientsRouteHandler.createTransition()
        createVC.1.onFlowCompleted({ student in
            /// Safety check
            guard let student = student else {
                return
            }
            
            let title = student.fullName != nil ? "\(student.fullName!) addedd successfully" : "Student added successfully"
            DefaultNotificationView.showNotification(controller: self, title: title, image: #imageLiteral(resourceName: "client_navigation_icon"), inset: UIEdgeInsets(top: 167, left: 0, bottom: 0, right: 0))
        })
        
        presentVC(createVC.0)
        
        /// Analytics
        Analytics.trackEventWithID(.s5_0)
    }
    
    /// Dismiss keyboard
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - CollectionView Delegate
extension ClientsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ClientsCollectionViewCell
        
        /// Safety check
        guard let student = cell.student else {
            return
        }
        
        /// Analytics
        Analytics.trackEventWithID(.s5_2, eventParams: ["id": student.id])
        
        /// Fech latest student data + push
        ClientsRouteHandler.clientTransition(student: student).then { response-> Void in
            
            /// Safety check
            guard let response = response else {
                return
            }
         
            /// Present
            self.presentVC(response)
            }.catch { error in
                print(error)
        }
    }
}

// MARK: - CollectionView Datasource
extension ClientsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 84)
    }
}

// MARK: - CollectionView Datasource
extension ClientsViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return studentsMonitor.numberOfObjects()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        /// Student
        let student = studentsMonitor[indexPath]
        
        /// Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ClientsCollectionViewCell.self)", for: indexPath) as! ClientsCollectionViewCell
        cell.student = student
        
        /// Check if need to hide separator
        let isNeedToHideSeparator = indexPath.row == studentsMonitor.numberOfObjects() - 1
        cell.dividerView.isHidden = isNeedToHideSeparator
        
        return cell
    }
}

// MARK: - Empty datasource
extension ClientsViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No Students", attributes: [NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 20), NSForegroundColorAttributeName: UIColor.black])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Please add student", attributes: [NSFontAttributeName: UIFont.defaultFont(size: 17), NSForegroundColorAttributeName: UIColor.trinidad])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "empty")
    }
}

// MARK: - Empty delegate
extension ClientsViewController: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        onAddButton()
    }
}
