//
//  CreateLearningPlanFlow.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PromiseKit
import SVProgressHUD
import EZSwiftExtensions

class CreateLearningPlanFlow: UINavigationController, FlowsProtocol {
    
    /// Request params
    var requestParams: LearningPlanCreation = LearningPlanCreation()
    
    /// Is modal
    var isModal: Bool = true
    
    /// Student
    var student: Student
    
    /// Learning plan
    var learningPlan: LearningPlan?
    
    /// Title
    var navTitle: String  = "Create Learning Plan"
    
    /// Flow controllers
    var controllers: [UIViewController] = []
    
    /// Number of steps
    var numberOfSteps: Int = 4
    
    /// Current step
    var currentStep: Int = 1
    
    /// Subjects VC
    lazy var subjectsVC: StudentSubjectViewController = {
        
        let vc = StudentSubjectViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { subject in
            
            /// Update dimention vc
            self.requestParams.subject = subject
            
            /// Add subject call
            SubjectAdapter.addSubject(subjectID: subject.id!, student: self.student).then { _-> Promise<[ProgressDimention]> in
             
                self.currentStep += 1
                
                /// Push cancellation VC
                return SubjectAdapter.fetchDimentions(subject: subject)
                }.then { _-> Void in

                    /// Permissions check
                    let config = Config.shared
                    if let cancellationPolicy = config.permissions?.cancellationPolicy, cancellationPolicy.isEnabled == true {
                        
                        /// Push cancellation policy
                        vc.pushVC(self.cancellationVC)
                        
                        return
                    }

                    vc.pushVC(self.rateVC)
                }.catch { error in
                    /// error handling
                    BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .all)
            }
        }
        
        return vc
    }()
    
    /// Cancellation VC
    lazy var cancellationVC: LearningPlanCancellationViewController = {
        
        let vc = LearningPlanCancellationViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.student = self.student
        vc.onNextButtonCallback { cancelationPlan in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.cancelation = cancelationPlan
            
            /// Set cancelation plan
            StudentAdapter.setCancelation(cancelationPlan, student: self.student).then { _-> Void in
             
                /// Push Rate VC
                vc.pushVC(self.rateVC)
                
                }.catch { error in
                  BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .all)
            }
        }
        
        return vc
    }()
    
    /// Dimentions VC
    lazy var dimentionsVC: LearningPlanProgressViewController = {
       
        let vc = LearningPlanProgressViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        if let subject = self.student.subjectsArray.first {
            vc.subject = subject
        }
        else if let subject = self.requestParams.subject {
            vc.subject = subject
        }

        vc.onNextButtonCallback { dimentions in

            self.currentStep += 1

            /// Update params
            self.requestParams.progressDimention = dimentions

            vc.pushVC(self.goalsVC)
        }
        
        return vc
    }()
    
    /// Rate VC
    lazy var rateVC: LearningPlanRateViewController = {
        
        let createVC = ScheduleRouteHandler.createTransition(student: self.student, isBLockSpinner: true)
        let vc = LearningPlanRateViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        
        vc.student = self.student
        vc.onNextButtonCallback { rate, duration, frequency, endDate in
            
            /// Update params
            self.requestParams.frequency = frequency
            self.requestParams.endDate = endDate
            
            /// Update student with rate, duration
            StudentAdapter.update(student: self.student, rate: rate, duration: duration).then { _-> Void in
             
                if self.student.sessionsArray.count == 0 {
                    
                    createVC.onFlowCompleted { _ in
                        
                        self.currentStep += 1
                        vc.pushVC(self.dimentionsVC)
                    }
                    
                    vc.presentVC(createVC)
                    
                    return
                }
                
                self.currentStep += 1
                
                /// Goals VC
                vc.pushVC(self.dimentionsVC)
                }.catch { error in
                    BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .all)
            }
        }
        
        return vc
    }()
    
    /// Goals VC
    lazy var goalsVC: LearningPlanGoalsViewController = {
       
        let vc = LearningPlanGoalsViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.student = self.student
        
        vc.onNextButtonCallback { goals in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.goalsNote = goals
            
            /// Expectations VC
            vc.pushVC(self.expectationVC)
        }
        
        return vc
    }()
    
    /// Expectations VC
    lazy var expectationVC: LearningPlanExpectationViewController = {
        
        let vc = LearningPlanExpectationViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { progress, workTime in
            
            /// Update params
            self.requestParams.expectedNode = progress
            self.requestParams.outsideWork = workTime
            
            self.currentStep += 1
            
            /// Create learning plan
            SVProgressHUD.show()
            LearningPlanAdapter.create(student: self.student, model: self.requestParams).then { response-> Void in
             
                /// Update learning plan
                self.learningPlan = response
                
                /// Send vc
                SVProgressHUD.dismiss()
                vc.pushVC(self.sendVC)
                
                }.catch { error in
                    SVProgressHUD.dismiss()
                    BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .all)
            }
        }
        
        return vc
    }()
    
    /// Send VC
    lazy var sendVC: LearningPlanSendViewController = {
        
        let vc = LearningPlanSendViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.learningPlan = self.learningPlan
        vc.onNextButtonCallback { _ in
            self.flowCompleted?(self.learningPlan)
        }
        
        return vc
    }()
    
    /// Flow conpleted
    var flowCompleted: ((LearningPlan?)->())?
    
    /// Completion setup
    func onFlowCompleted(_ completion: @escaping ((LearningPlan?)->())) {
        flowCompleted = completion
    }
    
    // MARK: - Custom init
    init(student: Student) {
        
        self.student = student
        super.init(nibName: nil, bundle: nil)
        
        // Setup banner code
        BannerManager.manager.viewController = self
        BannerManager.manager.errorMessageHiddenForCategory = { category in
            print(category)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
