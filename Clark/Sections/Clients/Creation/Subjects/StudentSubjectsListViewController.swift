//
//  StudentSubjectsListViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/28/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import SVProgressHUD

class StudentSubjectsListViewController: UIViewController, ListSectionObserver {
    
    /// Selected subjects
    var selectedSubjects: [Subject] = [] {
        didSet {
            
            /// Update title
            addSubjectButton.isHidden = selectedSubjects.count == 0
            
            /// Set title
            addSubjectButton.setTitle("Add \(selectedSubjects.count) subjects", for: .normal)
        }
    }
    
    /// Search textField
    lazy var searchView: SearchView = {
        
        /// Search view
        let searchView = SearchView()
        searchView.backgroundColor = UIColor.lightTrinidad
        
        searchView.backgroundColor = UIColor.white
        
        searchView.searchIcon.tintColor = UIColor.black
        searchView.cancelButton.tintColor = UIColor.black
        searchView.searchTextField.textColor = UIColor.black
        searchView.searchTextField.tintColor = UIColor.trinidad
        
        searchView.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.defaultFont(size: 18)])
        
        return searchView
    }()
    
    /// Add subjects button
    lazy var addSubjectButton: UIButton = {
        
        let button = UIButton()
        
        button.backgroundColor = UIColor.trinidad
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(style: .medium, size: 16)
        
        return button
    }()
    
    /// Subjects list
    lazy var subjectMonitor: ListMonitor<Subject> = {
        
        /// Fetch subjects for current tutor
        return self.generateMonitor()
    }()
    
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
        
        /// Register cells
        collectionView.register(SubjectSelectionCell.self, forCellWithReuseIdentifier: "\(SubjectSelectionCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("Select Subject")
        
        /// Back icon
        setCustomBackButton(image: #imageLiteral(resourceName: "back_icon")) {
            self.popVC()
        }
        
        /// Add action
        addSubjectButton.addTarget(self, action: #selector(onSelect), for: .touchUpInside)
        
        /// Custom init
        customInit()
        
        /// Fetch all subjects
        SubjectAdapter.fetch().catch { error in
            print(error)
        }
        
        /// Add monitor
        subjectMonitor.addObserver(self)
    }
    
    func customInit() {
        
        /// Collection setup
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Inset
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
        
        /// Collectoin layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view).offset(50)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
        
        /// Add subject button
        view.addSubview(addSubjectButton)
        addSubjectButton.isHidden = true
        addSubjectButton.snp.updateConstraints { maker in
            maker.bottom.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.height.equalTo(60)
        }
        
        view.addSubview(searchView)
        searchView.snp.updateConstraints({ maker in
            maker.left.equalTo(self.view)
            maker.top.equalTo(self.view)
            maker.height.equalTo(50)
            maker.width.equalTo(self.view)
        })
        
        /// Handle text did chage
        searchView.textDidChange({ text in
            self.searchTextChanged(text ?? "")
        })
        
        /// Clear button
        searchView.onClearButton({
            self.selectedSubjects = []
            self.searchTextChanged("")
            self.view.endEditing(true)
        })
        
        /// Add search border
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        border.frame = CGRect(x: 0, y: 48, width: view.size.width, height: 50)
        
        border.borderWidth = width
        searchView.layer.addSublayer(border)
        searchView.layer.masksToBounds = true
    }
    
    // MARK: ListObjectObserver
    func listMonitorDidChange(_ monitor: ListMonitor<Subject>) {
        collectionView.reloadData()
    }
    
    func listMonitorDidRefetch(_ monitor: ListMonitor<Subject>) {
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    func onSelect() {
        
        let ids: [[String: Any]] = selectedSubjects.flatMap { ["type": "subjects", "id": $0.id] }
        
        SVProgressHUD.show()
        /// Do networking call
        SubjectAdapter.addSubjects(subjectIDs: ids).then { response-> Void in
            SVProgressHUD.dismiss()
            self.popVC()
            }.catch { error in
                SVProgressHUD.dismiss()
                print(error)
        }
    }
    
    // MARK: - Search
    /// Clear button
    func onClearButton() {
        self.searchTextChanged("")
        self.view.endEditing(true)
    }
    
    /// Search
    func searchTextChanged(_ text: String) {
        
        if text.length > 0 {
            
            let nameParams = "\(SubjectAttributes.name.rawValue)"
            
            subjectMonitor.refetch(Where("\(nameParams) CONTAINS[c] %@", text), OrderBy(.ascending(SubjectAttributes.name.rawValue)))
            
            return
        }
        
        /// Reset monitor
        subjectMonitor = generateMonitor()
        subjectMonitor.addObserver(self)
        collectionView.reloadData()
    }
    
    func generateMonitor()-> ListMonitor<Subject> {
        return DatabaseManager.defaultStack.monitorList(From<Subject>(),
                                                 OrderBy(.ascending(SubjectAttributes.name.rawValue)))
    }
    
    // MARK: - Scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Disable dismiss for small phones
        if UIDevice.current.screenType != .iPhone5 {
            view.endEditing(true)
        }
    }
}

// MARK: - CollectionView Datasource
extension StudentSubjectsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}

// MARK: - CollectionView Delegate
extension StudentSubjectsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// Get selected subject, update cell
        let cell = collectionView.cellForItem(at: indexPath) as! SubjectSelectionCell
        cell.isButtonSelected = !cell.isButtonSelected
        
        /// Remove / add subjets
        if cell.isButtonSelected {
            selectedSubjects.append(cell.subject)
        }
        else {
            selectedSubjects.removeFirst(cell.subject)
        }
    }
}

// MARK: - CollectionView Datasource
extension StudentSubjectsListViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return subjectMonitor.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return subjectMonitor.numberOfObjectsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {

        let subject = subjectMonitor[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SubjectSelectionCell.self)", for: indexPath) as! SubjectSelectionCell
        
        cell.subject = subject
        cell.dividerView.isHidden = indexPath.row == subjectMonitor.numberOfObjects()
        cell.isButtonSelected = selectedSubjects.contains(subject)
        
        return cell
    }
}
