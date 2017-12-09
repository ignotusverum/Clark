//
//  ScheduleViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/17/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Hero
import CoreStore
import PromiseKit
import Foundation
import SVProgressHUD
import DZNEmptyDataSet
import EZSwiftExtensions

class ScheduleViewController: UIViewController, ListSectionObserver, LargeNavigationControllerProtocol {
    
    /// Delegate
    var delegate: LargeNavigationControllerDelegate?
    
    /// Session index closest to current date
    var closestSessionIndexPath: IndexPath = IndexPath(item: 0, section: 0)
    
    /// Navigation extension
    lazy var navigationExtension: ExtendedNavBarView = self.generateNavigationView(title: "Schedule", image: #imageLiteral(resourceName: "schedule_add_icon"))
    
    /// List monitor
    lazy var sessionsMonitor: ListMonitor<Session> = {
        return self.generateMonitor()
    }()
    
    /// Scroll to today button]
    lazy var scrollToTodayButton: ScrollToTodayButton = {
        return ScrollToTodayButton()
    }()
    
    /// Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Collection view
    lazy var collectionView: UICollectionView = self.generateCollectionView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Fetch data
        fetchSessions()
        
        /// Permissions check
        let config = Config.shared
        guard let permissions = config.permissions else {
            return
        }
        
        /// Update UI based on permissoins
        navigationExtension.isRightButtonEnabled = permissions.sessionAdd?.isEnabled ?? false
    }
    
    // MARK: - Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Analytics
        Analytics.screen(screenId: .s4)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Setup
        customInit()
        
        /// Fetch
        SessionAdapter.fetchList().then { response-> Void in

            ez.runThisAfterDelay(seconds: 0.1, after: {
              
                self.scrollToClosestSession()
            })

            }.catch { error in
            print(error)
        }
    }
    
    /// Custom setup
    private func customInit() {
        
        /// Add observer
        sessionsMonitor.addObserver(self)
        
        /// Collection
        view.addSubview(collectionView)
        
        /// Delegate
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Empty source delegate
        collectionView.emptyDataSetSource = self
        collectionView.emptyDataSetDelegate = self
        
        /// Scroll to today button
        view.addSubview(scrollToTodayButton)
        scrollToTodayButton.addTarget(self, action: #selector(scrollToClosestSession), for: .touchUpInside)
        
        /// Register cells
        collectionView.register(ScheduleCollectionViewCell.self, forCellWithReuseIdentifier: "\(ScheduleCollectionViewCell.self)")
        collectionView.register(ScheduleCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(ScheduleCollectionReusableView.self)")
        
        /// Navigation bar
        view.addSubview(navigationExtension)
        
        let top = UIDevice.current.systemVersion.compare("11",
                                                         options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending ? 147 : 167
        /// Collection layout
        collectionView.snp.updateConstraints { maker in
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.top.equalTo(top)
            maker.bottom.equalTo(self.view)
        }
        
        /// Layout - navigation extension view
        navigationExtension.snp.updateConstraints { maker-> Void in
            maker.height.equalTo(167)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.top.equalTo(view)
        }
        
        /// Scroll to today button layout
        scrollToTodayButton.snp.updateConstraints { maker in
            maker.width.equalTo(180)
            maker.height.equalTo(40)
            maker.bottom.equalTo(40)
            maker.centerX.equalTo(self.view)
        }
        
        /// Scroll to today shadow
        scrollToTodayButton.layer.cornerRadius = 8
        scrollToTodayButton.clipsToBounds = true
        scrollToTodayButton.addShadow(cornerRadius: 8)
        
        /// Find closest date
        findClosestDate(enableScroll: true)
    }
    
    /// Fetching students from server
    private func fetchSessions() {
        
        /// Fetch
        SessionAdapter.fetchList().catch { error in
            print(error)
        }
    }
    
    // MARK: ListObjectObserver
    func listMonitorDidChange(_ monitor: ListMonitor<Session>) {
        collectionView.reloadData()
        findClosestDate()
    }
    
    func listMonitorDidRefetch(_ monitor: ListMonitor<Session>) {
        collectionView.reloadData()
        findClosestDate()
    }
    
    // MARK: - Utilities
    
    func generateMonitor()-> ListMonitor<Session> {
        return DatabaseManager.defaultStack.monitorSectionedList(From<Session>(),
                                                        SectionBy("\(SessionAttributes.orderingDate.rawValue)"),
                                                        Where("\(SessionAttributes.statusString.rawValue) != %@", SessionStatus.cancelled.rawValue),
                                                        OrderBy(.ascending(SessionAttributes.startTime.rawValue)))
    }
    
    
    /// Find session closest to current date
    ///
    /// - Parameter enableScroll: enable scrolling
    func findClosestDate(enableScroll: Bool = false) {
        let closestSession = Session.findClosesSession(list: sessionsMonitor.objectsInAllSections())
        
        /// Safety check
        guard let response = closestSession else {
            return
        }
        
        /// Check if section exists
        if let indexPath = self.sessionsMonitor.indexPathOf(response) {
            
            self.closestSessionIndexPath = indexPath
        }
    }
    
    /// Clear button
    func onClearButton() {
        self.searchTextChanged("")
        self.view.endEditing(true)
    }
    
    /// Search
    func searchTextChanged(_ text: String) {
        
        if text.length > 0 {
            
            let fullNameParams = "\(SessionRelationships.student.rawValue).\(StudentAttributes.fullName.rawValue)"
            
            sessionsMonitor.refetch(Where("\(fullNameParams) CONTAINS[c] %@ AND \(SessionAttributes.statusString.rawValue) != %@", text, SessionStatus.cancelled.rawValue), OrderBy(.ascending(SessionAttributes.startTime.rawValue)))
            
            /// Analytics
            Analytics.trackEventWithID(.s4_1, eventParams: ["text": text])
            
            return
        }
        
        /// Reset monitor
        sessionsMonitor = generateMonitor()
        sessionsMonitor.addObserver(self)
        collectionView.reloadData()
    }
    
    /// Trigger kickoff
    func onAddButton() {
        
        let createVC = ScheduleRouteHandler.createTransition(student: nil)
        createVC.onFlowCompleted({ session in
            /// Safety check
            guard let session = session else {
                return
            }
            
            let title = session.student?.firstName != nil ? "Session with \(session.student!.firstName!) created successfully" : "Session created successfully"
            DefaultNotificationView.showNotification(controller: self, title: title, image: #imageLiteral(resourceName: "schedule_navigation_icon"), inset: UIEdgeInsets(top: 167, left: 0, bottom: 0, right: 0))
        })
        
        presentVC(createVC)
    }
    
    /// Dismiss keyboard
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
     
        /// Check if need to present scroll button
        DispatchQueue.main.async {
            let visibleSections = self.collectionView.indexPathsForVisibleItems
            
            /// If not currently visible & not presented
            let shouldShow = !visibleSections.contains(self.closestSessionIndexPath)
            
            /// Run animation
            self.shouldShowScrollToTodayButton(shouldShow)
        }
    }
    
    func scrollToClosestSession() {
        
        if collectionView.numberOfSections > closestSessionIndexPath.section {
            if collectionView.numberOfItems(inSection: closestSessionIndexPath.section) > closestSessionIndexPath.row {
                
                collectionView.scrollToItem(at: closestSessionIndexPath, at: .top, animated: true)
                shouldShowScrollToTodayButton(false)
            }
        }
    }
    
    func shouldShowScrollToTodayButton(_ shouldShow: Bool) {
        
        if navigationExtension.searchView.searchTextField.text?.length == 0 {
            let bottomPosition = shouldShow == true ? -40 : 40
            
            UIView.animate(withDuration: 0.2, animations: {
                /// Scroll to today button layout updates
                self.scrollToTodayButton.snp.updateConstraints { maker in
                    maker.bottom.equalTo(bottomPosition)
                }
                
                self.view.layoutSubviews()
            })
        }
    }
}

// MARK: - CollectionView Delegate
extension ScheduleViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ScheduleCollectionViewCell
        
        /// Schedule details flow
        guard let session = cell.session else {
            return
        }
        
        let _ = ScheduleRouteHandler.scheduleTransition(session: session).then { response-> Void in
         
            /// Safety check
            guard let response = response else {
                return
            }
            
            /// Analytics
            Analytics.trackEventWithID(.s4_2, eventParams: ["id": session.id])
            
            /// Transition
            self.presentVC(response)
        }
    }
}

// MARK: - CollectionView Datasource
extension ScheduleViewController: UICollectionViewDelegateFlowLayout {
    /// Item size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    /// Section insets
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
    }
    
    /// Section header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let defaultHeaderSize = CGSize(width: collectionView.frame.width, height: 44)
        /// Always show for first
        if section == 0 {
            return defaultHeaderSize
        }
        
        if let currentItem = sessionsMonitor.objectsInSection(section).first, let previousItem = sessionsMonitor.objectsInSection(section - 1).first {
            
            if currentItem.headerString == previousItem.headerString {
             
                return .zero
            }
        }
        
        return defaultHeaderSize
    }
    
    /// Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            /// Header setup
            let session = sessionsMonitor[indexPath]
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ScheduleCollectionReusableView.self)", for: indexPath) as! ScheduleCollectionReusableView
            
            headerView.session = session
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Datasource
extension ScheduleViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return sessionsMonitor.numberOfSections()
    }
    
    /// Number of objects
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return sessionsMonitor.numberOfObjectsInSection(section)
    }
    
    /// Item for indexPath
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let session = sessionsMonitor[indexPath]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ScheduleCollectionViewCell.self)", for: indexPath) as! ScheduleCollectionViewCell
        
        cell.session = session
        
        var firstOfDay = true
        if indexPath.row != 0 {
            let previousSession = sessionsMonitor[IndexPath(item: indexPath.row - 1, section: indexPath.section)]
            firstOfDay = previousSession.startTime?.day != session.startTime?.day
        }
        
        // Configure left date labels
        cell.dayNumberLabel.isHidden = !firstOfDay
        cell.dayOfWeekLabel.isHidden = !firstOfDay
        if firstOfDay {
            cell.dayNumberLabel.text = session.localStartTime(format: "d")
            cell.dayOfWeekLabel.text = session.localStartTime(format: "E")
        }
        
        return cell
    }
}

// MARK: - Empty datasource
extension ScheduleViewController: DZNEmptyDataSetSource {
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No Sessions", attributes: [NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 20), NSForegroundColorAttributeName: UIColor.black])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Please create a session", attributes: [NSFontAttributeName: UIFont.defaultFont(size: 17), NSForegroundColorAttributeName: UIColor.trinidad])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "empty")
    }
}

// MARK: - Empty delegate
extension ScheduleViewController: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        onAddButton()
    }
}
