//
//  CreateSessionFlow.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PromiseKit
import SVProgressHUD

class CreateSessionFlow: UINavigationController, FlowsProtocol {
    
    /// Student
    var student: Student?
    
    /// Flow conpleted
    var flowCompleted: ((Session?) -> ())?
    
    /// Is modal
    var isModal: Bool = true
    
    /// Is blocked spinner
    var isBlockedSpinner = false
    
    /// Request params
    var requestParams: SessionCreation = SessionCreation()
    
    /// Title
    var navTitle: String  = "New Session"
    
    /// Flow controllers
    var controllers: [UIViewController] = []
    
    /// Number of steps
    var numberOfSteps: Int = 4
    
    /// Current step
    var currentStep: Int = 1
    
    /// student VC
    lazy var studentVC: SessionStudentViewController = {
        
        let vc = SessionStudentViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { student in
            
            self.student = student
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.student = student
            
            /// Rate VC
            vc.pushVC(self.rateVC)
        }
        
        return vc
    }()
    
    /// Note VC
    lazy var noteVC: SessionNoteViewController = {
        
        let vc = SessionNoteViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { note in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.notes = note
            
            let config = Config.shared
            /// If everything disabled, just create session
            if let permissions = config.permissions, permissions.automatedSessionBooking == nil && permissions.sessionReminders == nil {
                
                self.createSession()
                return
            }
            
            /// Recurring
            vc.pushVC(self.recurringVC)
        }
        
        return vc
    }()
    
    /// Recurring VC
    lazy var recurringVC: SessionRecurringViewController = {
        
        let vc = SessionRecurringViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.student = self.student
        vc.onNextButtonCallback { isRecurring, isReminder in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.isRecurring = isRecurring
            self.requestParams.isNeedToRemind = isReminder
            
            /// Create session
            self.createSession()
        }
        
        return vc
    }()
    
    /// Rate VC
    lazy var rateVC: SessionRateViewController = {
        
        let vc = SessionRateViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.student = self.student
        vc.onNextButtonCallback { rate, duration, date, time in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.rate = rate
            self.requestParams.duration = duration
            
            self.requestParams.startDate = date
            self.requestParams.startTime = time
            
            /// Recurring VC
            vc.pushVC(self.noteVC)
        }
        
        return vc
    }()

    
    /// Completion setup
    func onFlowCompleted(_ completion: @escaping ((Session?)->())) {
        flowCompleted = completion
    }
    
    // MARK: - Init
    init(student: Student?, isBlockedSpinner: Bool = false) {
        
        self.student = student
        self.isBlockedSpinner = isBlockedSpinner
        super.init(nibName: nil, bundle: nil)
        
        if student == nil {
            setViewControllers([studentVC], animated: false)
        }
        else {
            requestParams.student = student
            setViewControllers([rateVC], animated: false)
        }
        
        // Setup banner code
        BannerManager.manager.viewController = self
        BannerManager.manager.errorMessageHiddenForCategory = { category in
            print(category)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Utilities
    func createSession() {
        
        if !self.isBlockedSpinner {
            SVProgressHUD.show()
        }
        
        /// Create session call
        SessionAdapter.create(model: self.requestParams).then { response-> Void in
            
            SVProgressHUD.dismiss()
            
            /// Callback
            self.flowCompleted?(response)
            
            /// Modal check
            if self.isModal {
                self.dismissVC(completion: nil)
                return
            }
            
            /// Not modal
            self.popToRootViewController(animated: true)
            
            }.catch { error in
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
                /// Show error
                BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .all)
        }
    }
}

