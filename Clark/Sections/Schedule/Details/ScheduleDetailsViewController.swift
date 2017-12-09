//
//  ScheduleDetailsViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/3/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PromiseKit
import CoreStore
import SVProgressHUD
import EZSwiftExtensions

/// Type of cells
enum ScheduleDetailsCells: String {
    
    case date
    
    case student
    
    case addSessionReport
    
    case payment
    case location
    
    case feedbackBody
    case feedbackRating
    case feedbackPositive
    case feedbackNegative
    
    case futureNotes
    case notes
    case reminders
    
    case reschedule
}

class ScheduleDetailsViewController: UIViewController, ObjectObserver {
    
    typealias ObjectEntityType = SessionReport
    
    /// Session observer
    var monitor: ObjectMonitor<SessionReport>?
    
    /// Session
    var session: Session
    
    /// Datasource
    var datasource: [ScheduleDetailsCells] = [.date, .addSessionReport, .student, .payment, .feedbackBody, .feedbackRating, .feedbackPositive, .feedbackNegative, .reminders]
    
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
        
        /// Cell registration
        collectionView.register(SessionDetailsHeaderCell.self, forCellWithReuseIdentifier: "\(SessionDetailsHeaderCell.self)")
        collectionView.register(SessionDetailsProgressCell.self, forCellWithReuseIdentifier: "\(SessionDetailsProgressCell.self)")
        collectionView.register(SessionDetailsStudentCell.self, forCellWithReuseIdentifier: "\(SessionDetailsStudentCell.self)")
        collectionView.register(SessionDetailsPriceCell.self, forCellWithReuseIdentifier: "\(SessionDetailsPriceCell.self)")
        collectionView.register(SessionDetailsPositiveFeedbackCell.self, forCellWithReuseIdentifier: "\(SessionDetailsPositiveFeedbackCell.self)")
        collectionView.register(SessionDetailsNegativeFeedbackCell.self, forCellWithReuseIdentifier: "\(SessionDetailsNegativeFeedbackCell.self)")
        collectionView.register(SessionDetailsAddSessionReportCell.self, forCellWithReuseIdentifier: "\(SessionDetailsAddSessionReportCell.self)")
        collectionView.register(SessionDetailsReportCell.self, forCellWithReuseIdentifier: "\(SessionDetailsReportCell.self)")
        collectionView.register(SessionDetailsRescheduleCell.self, forCellWithReuseIdentifier: "\(SessionDetailsRescheduleCell.self)")
        collectionView.register(SessionDetailsReminders.self, forCellWithReuseIdentifier: "\(SessionDetailsReminders.self)")
        
        return collectionView
    }()
    
    // MARK: - Init
    init(session: Session) {
        self.session = session
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ScheduleDetailsViewController aDecoder not implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Analytics
        Analytics.screen(screenId: .s7)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.white
        
        /// Title
        setTitle("Session Details")
        
        /// Back icon
        setCustomBackButton(image: #imageLiteral(resourceName: "back_icon")) {
            self.navigationController?.heroModalAnimationType = .slide(direction: .right)
            self.navigationController?.hero_dismissViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.monitor?.addObserver(self)
        
        // Setup banner code
        BannerManager.manager.viewController = self
        BannerManager.manager.errorMessageHiddenForCategory = { category in
            print(category)
        }
        
        /// Custom init
        customInit()
    }
    
    func customInit() {
        
        /// Collection view
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.bottom.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
        }
    }
    
    // MARK: - Utilities
    fileprivate func presentRescheduleAlert() {
        
        /// Alert VC
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertVC.view.tintColor = UIColor.trinidad
        
        /// Cancel action
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(alertCancel)
        
        /// Cancel action
        let cancelAction = UIAlertAction(title: "Cancel Session", style: .default) { action in
            
            /// Dismiss action sheet
            alertVC.dismissVC(completion: nil)
            
            /// Cancel verification
            let fullNameSuffix = self.session.student?.fullName != nil ? " with \(self.session.student!.fullName!)" : ""
            let cancelAlert = UIAlertController(title: "Warning", message: "Are you sure you want to cancel session\(fullNameSuffix)", preferredStyle: .alert)
            
            /// Cancel action
            cancelAlert.addAction(alertCancel)
            
            /// Yes action
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
                self.handleCancellation()
            })
            cancelAlert.addAction(yesAction)
            
            /// Show alert
            self.presentVC(cancelAlert)
        }
        
        /// Reschedule action
        let rescheduleAction = UIAlertAction(title: "Reschedule Session", style: .default) { action in
            
            /// Dismiss action sheet
            alertVC.dismissVC(completion: nil)
            
            /// Reschedule verification
            let alert = UIAlertController(title: "Warning", message: "Not handled yet ", preferredStyle: .alert)
            
            /// Alert cancel
            alert.addAction(alertCancel)
            
            self.presentVC(alert)
        }
        
        /// Update actions
        alertVC.addAction(rescheduleAction)
        alertVC.addAction(cancelAction)
        
        /// Present action sheet
        presentVC(alertVC)
    }
    
    fileprivate func handleCancellation() {
        
        /// Loader
        SVProgressHUD.show()
        
        /// Networking call
        /// Update status to cancel
        SessionAdapter.update(session, dict: [SessionJSON.statusString: SessionStatus.cancelled.rawValue]).then { response-> Void in
            
            SVProgressHUD.dismiss()
            self.popVC()
            
            }.catch { error in
         
                SVProgressHUD.dismiss()
                BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .loginSignUp)
        }
    }
    
    func objectMonitor(_ monitor: ObjectMonitor<SessionReport>, didUpdateObject object: SessionReport, changedPersistentKeys: Set<RawKeyPath>) {
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Delegate
extension ScheduleDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellType = datasource[indexPath.row]
        
        /// Analytics
        Analytics.trackEventWithID(.s7_1, eventParams: ["type": cellType.rawValue])
        
        if cellType == .reschedule {
            /// Handle reschedule logic
            presentRescheduleAlert()
        }
        else if cellType == .addSessionReport {

            /// Analytics
            Analytics.trackEventWithID(.s7_0, eventParams: ["id": session.id])
            
            /// Present learning plan flow
            if let student = session.student, student.learningPlanArray.count == 0 {
                
                let learningPlanFlow = ClientsRouteHandler.createLearningPlanTransition(student: student)
                
                /// Called when session created
                learningPlanFlow.1.onFlowCompleted({ _ in

                    /// Delay fixes
                    ez.runThisAfterDelay(seconds: 0.2, after: { 
                      
                        /// Transition to create new session report
                        let sessionReport = ScheduleRouteHandler.createSessionReportTransition(session: self.session)
                        sessionReport.1.onFlowCompleted { result-> Void in
                            
                            /// Safety check
                            guard let result = result else {
                                return
                            }
                            
                            let title = result.student?.firstName != nil ? "Session report for \(result.student!.firstName!) added successfully" : "Session report added successfully"
                            DefaultNotificationView.showNotification(controller: self, title: title, image: #imageLiteral(resourceName: "schedule_navigation_icon"))
                        
                            if let report = result.sessionReport {
                                self.monitor = DatabaseManager.defaultStack.monitorObject(report)
                                self.monitor?.addObserver(self)
                            }
                            
                            ez.runThisAfterDelay(seconds: 0.3, after: {
                                
                                self.session = result
                                self.collectionView.reloadData()
                            })
                            
                            self.dismissVC(completion: nil)
                        }
                        
                        self.presentVC(sessionReport.0)
                    })
                })
                
                presentVC(learningPlanFlow.0)
                
                return
            }
            
            /// Transition to create new session report
            let sessionReport = ScheduleRouteHandler.createSessionReportTransition(session: session)
            sessionReport.1.onFlowCompleted { result-> Void in
                
                /// Safety check
                guard let result = result else {
                    return
                }
                
                let title = result.student?.firstName != nil ? "Session report for \(result.student!.firstName!) added successfully" : "Session report added successfully"
                DefaultNotificationView.showNotification(controller: self, title: title, image: #imageLiteral(resourceName: "schedule_navigation_icon"))
                
                if let report = result.sessionReport {
                    self.monitor = DatabaseManager.defaultStack.monitorObject(report)
                    self.monitor?.addObserver(self)
                }
                
                ez.runThisAfterDelay(seconds: 0.3, after: {
                  
                    self.session = result
                    self.collectionView.reloadData()
                })
                
                self.dismissVC(completion: nil)
            }
            
            presentVC(sessionReport.0)
        }
    }
}

// MARK: - CollectionView Datasource
extension ScheduleDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        var cellHeight: CGFloat = 0
        
        let cellType = datasource[indexPath.row]
        switch cellType {
        case .date:
            cellHeight = SessionDetailsHeaderCell.calculatedHeight(session: session)
        case .student:
            cellHeight = SessionDetailsStudentCell.calculatedHeight(session: session)
        case .addSessionReport:
            cellHeight = 0
            
            /// Permissions check
            let config = Config.shared
            if let sessionsReportPermission = config.permissions?.sessionReport, sessionsReportPermission.isEnabled == true {
                cellHeight = SessionDetailsAddSessionReportCell.calculatedHeight(session: session)
            }
            
        case .feedbackRating:
            cellHeight = SessionDetailsProgressCell.calculatedHeight(session: session)
        case .feedbackBody:
            cellHeight = SessionDetailsReportCell.calculatedHeight(session: session)
        case .payment:
            cellHeight = SessionDetailsPriceCell.calculatedHeight(session: session)
        case .feedbackPositive:
            cellHeight = SessionDetailsPositiveFeedbackCell.calculatedHeight(session: session)
        case .feedbackNegative:
            cellHeight = SessionDetailsNegativeFeedbackCell.calculatedHeight(session: session)
        case .reschedule:
            cellHeight = SessionDetailsRescheduleCell.calculatedHeight(session: session)
        case .reminders:
            cellHeight = SessionDetailsReminders.calculatedHeight(session: session)
        default:
            cellHeight = 0
        }
        
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
}

// MARK: - CollectionView Datasource
extension ScheduleDetailsViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cellType = datasource[indexPath.row]
        
        /// Switch cell types
        switch cellType {
        case .date:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionDetailsHeaderCell.self)", for: indexPath) as! SessionDetailsHeaderCell
            
            cell.session = session
            cell.clipsToBounds = true
            
            return cell
        case .student:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionDetailsStudentCell.self)", for: indexPath) as! SessionDetailsStudentCell
            
            cell.session = session
            cell.clipsToBounds = true
            
            return cell
        case .addSessionReport:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionDetailsAddSessionReportCell.self)", for: indexPath) as! SessionDetailsAddSessionReportCell
            
            cell.session = session
            cell.clipsToBounds = true
            
            return cell
        case .payment:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionDetailsPriceCell.self)", for: indexPath) as! SessionDetailsPriceCell
            
            cell.session = session
            cell.clipsToBounds = true
            
            return cell
        case .feedbackRating:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionDetailsProgressCell.self)", for: indexPath) as! SessionDetailsProgressCell
            
            cell.session = session
            cell.clipsToBounds = true
            
            return cell
        case .feedbackBody:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionDetailsReportCell.self)", for: indexPath) as! SessionDetailsReportCell
            
            cell.session = session
            cell.clipsToBounds = true
            
            return cell
        case .feedbackPositive:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionDetailsPositiveFeedbackCell.self)", for: indexPath) as! SessionDetailsPositiveFeedbackCell
            
            cell.session = session
            cell.clipsToBounds = true
            
            return cell
        case .feedbackNegative:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionDetailsNegativeFeedbackCell.self)", for: indexPath) as! SessionDetailsNegativeFeedbackCell
            
            cell.session = session
            cell.clipsToBounds = true
            
            return cell
        case .reschedule:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionDetailsRescheduleCell.self)", for: indexPath) as! SessionDetailsRescheduleCell
            
            cell.session = session
            cell.clipsToBounds = true
            
            return cell
        case .reminders:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionDetailsReminders.self)", for: indexPath) as! SessionDetailsReminders
            
            cell.session = session
            cell.clipsToBounds = true
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
