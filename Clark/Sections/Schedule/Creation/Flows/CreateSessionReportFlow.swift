//
//  CreateSessionReportFlow.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PromiseKit
import SVProgressHUD
import EZSwiftExtensions

class CreateSessionReportFlow: UINavigationController, FlowsProtocol {
    
    /// Request params
    var requestParams: SessionReportCreation = SessionReportCreation()
    
    /// Is modal
    var isModal: Bool = true
    
    /// Session
    var session: Session
    
    /// Title
    var navTitle: String  = "Session Report"
    
    /// Flow controllers
    var controllers: [UIViewController] = []
    
    /// Number of steps
    var numberOfSteps: Int = 4
    
    /// Current step
    var currentStep: Int = 1
    
    /// Progress VC
    lazy var progressVC: SessionReportProgressViewController = {
       
        let vc = SessionReportProgressViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { progress in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.progress = progress
         
            /// Dimention
            vc.pushVC(self.noteVC)
        }
        
        return vc
    }()
    
    /// Note VC
    lazy var noteVC: SessionReportNoteViewController = {
       
        let vc = SessionReportNoteViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { note in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.note = note
            
            /// Dimention
            vc.pushVC(self.dimentionVC)
        }
        
        return vc
    }()
    
    /// Dimention VC
    lazy var dimentionVC: SessionReportDimentionViewController = {
        
        let vc = SessionReportDimentionViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.learningPlan = self.session.student?.learningPlansArray.first
        vc.onNextButtonCallback { dimention in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.improvement = dimention
            
            /// Check if there's dimensions left for improvement
            if vc.dimensions.count == dimention.count {
                
                /// Future Note
                vc.pushVC(self.futureNoteVC)
                return
            }
            
            /// Future Note
            vc.pushVC(self.dimentionImprovementVC)
        }
        
        return vc
    }()
    
    /// Improvement VC
    lazy var dimentionImprovementVC: SessionReportDimentionImprovementViewController = {
        
        let vc = SessionReportDimentionImprovementViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.excludeDimentions = self.requestParams.improvement
        vc.learningPlan = self.session.student?.learningPlansArray.first
        vc.onNextButtonCallback { dimention in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.whatWentWell = dimention
            
            /// Future Note
            vc.pushVC(self.futureNoteVC)
        }
        
        return vc
    }()
    
    /// Note VC
    lazy var futureNoteVC: SessionReportFutureNotesViewContoller = {
        
        let vc = SessionReportFutureNotesViewContoller(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { note in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.futureNote = note
            
            SVProgressHUD.show()
            
            /// Clear
            self.dismissVC(completion: nil)
            
            /// Create session report
            SessionReportAdapter.create(session: self.session, model: self.requestParams).then { _-> Void in
                
                SVProgressHUD.dismiss()
                
                ez.runThisAfterDelay(seconds: 5) {
                    
                    let _ = SessionReportAdapter.statusUpdate(session: self.session)
                }
                
                self.flowCompleted?(self.session)
                }.catch { error in
                    SVProgressHUD.dismiss()
                    BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .all)
            }
        }
        
        return vc
    }()
    
    init(session: Session) {
        
        self.session = session
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
    
    /// Flow conpleted
    var flowCompleted: ((Session)->())?
    
    /// Completion setup
    func onFlowCompleted(_ completion: @escaping ((Session?)->())) {
        flowCompleted = completion
    }
}
