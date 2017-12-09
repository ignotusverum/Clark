//
//  ClientDetailsSessionsViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore

protocol ClientDetailsSessionsViewControllerProtocol {
    
    /// Add session pressed
    func addSessionPressed()
}

class ClientDetailsSessionsViewController: UIViewController, ListSectionObserver {
    
    /// Session
    var student: Student
    
    /// Delegate
    var delegate: ClientDetailsSessionsViewControllerProtocol?
    
    /// Collection View
    var collectionView: UICollectionView = {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        
        /// Register
        collectionView.register(ClientDetailsSessionsCell.self, forCellWithReuseIdentifier: "\(ClientDetailsSessionsCell.self)")
        collectionView.register(SimpleActionCell.self, forCellWithReuseIdentifier: "\(SimpleActionCell.self)")
        collectionView.register(ClientDetailsHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(ClientDetailsHeaderView.self)")
        
        return collectionView
    }()
    
    /// List monitor
    lazy var sessionsMonitor: ListMonitor<Session> = {
        return DatabaseManager.defaultStack.monitorSectionedList(From<Session>(),
                                                                 SectionBy("\(SessionAttributes.studentDetailsOrdering.rawValue)"),
                                                                 Where("\(SessionAttributes.statusString.rawValue) != %@ && \(SessionRelationships.student.rawValue).\(ModelAttributes.id.rawValue) == %@", SessionStatus.cancelled.rawValue, self.student.id),
                                                                 OrderBy(.ascending(SessionAttributes.startTime.rawValue)))
    }()
    
    // MARK: - init
    init(student: Student) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ClientDetailsSessionsViewController adecoder not implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Custom init
        customInit()
    }
    
    // MARK: - Custom init
    private func customInit() {
        
        /// Add observer
        sessionsMonitor.addObserver(self)
        
        /// Collection view
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection view layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.bottom.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
        }
    }

    // MARK: ListObjectObserver
    func listMonitorDidChange(_ monitor: ListMonitor<Session>) {
        collectionView.reloadData()
    }
    
    func listMonitorDidRefetch(_ monitor: ListMonitor<Session>) {
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Delegate
extension ClientDetailsSessionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section < sessionsMonitor.numberOfSections() {
            let cell = collectionView.cellForItem(at: indexPath) as! ClientDetailsSessionsCell
            
            /// Safety check
            guard let session = cell.session else {
                return
            }
            
            /// Fech latest student data + push
            ScheduleRouteHandler.scheduleTransition(session: session).then { response-> Void in
                
                /// Safety check
                guard let response = response else {
                    return
                }
                
                /// Analytics
                Analytics.trackEventWithID(.s8_1, eventParams: ["cilentID": session.student?.id ?? "", "sessionID": session.id])
                
                /// Present
                self.presentVC(response)
                }.catch { error in
                    print(error)
            }
        }
        else {
            
            /// Transition to create new session
            let createSessionFlow = ScheduleRouteHandler.createTransition(student: student)
            
            /// Called when session created
            createSessionFlow.onFlowCompleted({ _ in
                SessionAdapter.fetchList().then { response-> Void in
                    self.collectionView.reloadData()
                    }.catch { _ in }
            })
            
            presentVC(createSessionFlow)
        }
    }
}

// MARK: - CollectionView Datasource
extension ClientDetailsSessionsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        var cellHeight: CGFloat = 66
        
        /// Permissions check
        let config = Config.shared
        if indexPath.section == sessionsMonitor.numberOfSections() {
            let sessionsPermissions = config.permissions?.sessionAdd
            cellHeight = sessionsPermissions?.isEnabled == true ? 66 : 0
        }
        
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    /// Section insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
    /// Section header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let defaultHeaderSize = CGSize(width: collectionView.frame.width, height: 50)
        return section < sessionsMonitor.numberOfSections() ? defaultHeaderSize : .zero
    }
    
    /// Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            /// Header setup
            let session = sessionsMonitor[indexPath]
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ClientDetailsHeaderView.self)", for: indexPath) as! ClientDetailsHeaderView
            
            headerView.type = session.studentDetailsOrdering!.boolValue ? .upcoming : .past
            
            return headerView
            
        default:
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Datasource
extension ClientDetailsSessionsViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return sessionsMonitor.numberOfSections() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return section < sessionsMonitor.numberOfSections() ? sessionsMonitor.numberOfObjectsInSection(section) : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        if indexPath.section < sessionsMonitor.numberOfSections() {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ClientDetailsSessionsCell.self)", for: indexPath) as! ClientDetailsSessionsCell
            
            let session = sessionsMonitor[indexPath]
            cell.session = session
            cell.type = session.studentDetailsOrdering!.boolValue ? .upcoming : .past
            cell.dividerView.isHidden = indexPath.row == sessionsMonitor.numberOfObjectsInSection(indexPath.section) - 1
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SimpleActionCell.self)", for: indexPath) as! SimpleActionCell
        cell.text = "Add session"
        
        return cell
    }
}
