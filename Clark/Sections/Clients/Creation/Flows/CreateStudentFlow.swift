//
//  CreateStudentFlow.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PromiseKit
import SVProgressHUD

class CreateStudentFlow: FlowsProtocol {
    
    /// Request params
    var requestParams: StudentCreation = StudentCreation()
    
    /// Is modal
    var isModal: Bool = true
    
    /// Title
    var navTitle: String  = "New Student"
    
    /// Student
    var student: Student?
    
    /// Need to show final
    var needToShowFinal: Bool = true
    
    /// Flow controllers
    var controllers: [UIViewController] = []
    
    /// Number of steps
    var numberOfSteps: Int = 4
    
    /// Current step
    var currentStep: Int = 1
    
    /// Name VC
    lazy var nameVC: StudentNameViewController = {
       
        let vc = StudentNameViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { firstName, lastName, isUnder13 in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.firstName = firstName
            self.requestParams.lastName = lastName
            
            if isUnder13 {

                /// Proxy
                vc.pushVC(self.proxyVC)

                return
            }

            /// Contacts type VC
            vc.pushVC(self.contactVC)
        }
        
        return vc
    }()
    
    /// Contact VC
    lazy var contactVC: StudentContactViewController = {
       
        let vc = StudentContactViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { email, phone in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.phone = phone
            self.requestParams.email = email

            /// Subjects VC
            vc.pushVC(self.subjectVC)
        }
        
        return vc
    }()
    
    /// Subject VC
    lazy var subjectVC: StudentSubjectViewController = {
        
        let vc = StudentSubjectViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { subject in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.subject = subject
            
            /// Subjects VC
            vc.pushVC(self.rateVC)
        }
        
        return vc
    }()
    
    /// Rate VC
    lazy var rateVC: StudentRateViewController = {
        
        let vc = StudentRateViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        
        vc.onNextButtonCallback { duration, rate in
            
            self.currentStep += 1
            
            /// Update params
            self.requestParams.rate = rate
            self.requestParams.duration = duration
            
            SVProgressHUD.show()
            
            /// Create student call
            StudentAdapter.create(model: self.requestParams).then { response-> (Promise<Bool>, student: Student?) in

                /// Assign subject
                return (SubjectAdapter.addSubject(subjectID: self.requestParams.subject?.id, student: response), response)
                }.then { (response, student)-> Promise<Student?> in
                    /// Create proxy
                    return StudentAdapter.createProxy(model: self.requestParams.proxy, student: student)
                }.then { response-> Void in
                    
                    /// Dismiss on success
                    SVProgressHUD.dismiss()
                    
                    self.student = response
                    
                    /// Completed callback
                    self.flowCompleted?(response)
                    
                    if !self.needToShowFinal {
                    
                        /// Modal check
                        if self.isModal {
                            vc.dismissVC(completion: nil)
                            return
                        }
                        
                        /// Not modal
                        vc.navigationController?.popToRootViewController(animated: false)
                        return
                    }
                    
                    let config = Config.shared
                    /// If everything disabled, dismiss
                    if let permissions = config.permissions, permissions.sessionAdd == nil && permissions.learningPlans == nil {
                        
                        vc.dismissVC(completion: nil)
                        return
                    }
                    
                    vc.pushVC(self.finalVC)
                    
                }.catch { error in
                    /// Show error
                    SVProgressHUD.dismiss()
                    BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .all)
            }
        }
        
        return vc
    }()
    
    /// Proxy VC
    lazy var proxyVC: StudentProxyViewController = {
        
        let vc = StudentProxyViewController(currentStep: self.currentStep, numberOfSteps: self.numberOfSteps, title: self.navTitle)
        vc.onNextButtonCallback { firstName, lastName, relationship, email, phone in
            
            self.currentStep += 1
            
            /// Update params
            let proxy = ProxyCreation(firstName: firstName, lastName: lastName, phoneNumber: phone, email: email, relation: relationship)
            self.requestParams.proxy = proxy
         
            /// Subjects VC
            vc.pushVC(self.subjectVC)
        }
        
        return vc
    }()
    
    /// Final VC
    lazy var finalVC: StudentCreationFinalViewController = {
       
        let vc = StudentCreationFinalViewController()
        vc.student = self.student
        vc.onNextButtonCallback {
            
            self.flowCompleted?(self.student)
            
            /// Modal check
            if self.isModal {
                vc.dismissVC(completion: nil)
                return
            }
            
            /// Not modal
            vc.navigationController?.popToRootViewController(animated: false)
        }
        
        return vc
    }()
    
    /// Flow conpleted
    var flowCompleted: ((Student?)->())?
    
    /// Completion setup
    func onFlowCompleted(_ completion: @escaping ((Student?)->())) {
        flowCompleted = completion
    }
}
