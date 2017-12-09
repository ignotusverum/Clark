//
//  HomeViewController+Parser.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/19/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import NMessenger
import SwiftyJSON
import PromiseKit
import SwiftMessages
import SVProgressHUD
import SKPhotoBrowser
import TwilioChatClient
import EZSwiftExtensions

extension HomeViewController: MessageParserDelegate {
    
    /// Card action tapped
    func cardActionTapped(type: CardDestinationType, id: String?) {
        
        switch type {
        case .student:
            
            /// Add student
            let createVC = ClientsRouteHandler.createTransition()
            createVC.1.onFlowCompleted({ student in
                /// Safety check
                guard let student = student else {
                    return
                }
                
                let title = student.fullName != nil ? "\(student.fullName!) addedd successfully" : "Student added successfully"
                DefaultNotificationView.showNotification(controller: self, title: title, image: #imageLiteral(resourceName: "client_navigation_icon"))
            })
            
            presentVC(createVC.0)
            
        case .session:
            
            /// Add session
            let createVC = ScheduleRouteHandler.createTransition(student: nil)
            createVC.onFlowCompleted({ session in
                /// Safety check
                guard let session = session else {
                    return
                }
                
                let title = session.student?.firstName != nil ? "Session with \(session.student!.firstName!) created successfully" : "Session created successfully"
                DefaultNotificationView.showNotification(controller: self, title: title, image: #imageLiteral(resourceName: "schedule_navigation_icon"))
            })
            presentVC(createVC)
            
        case .sessionReport:
            
            /// Safety check
            guard let id = id else {
                return
            }
            
            SVProgressHUD.show()
            
            /// Fetch session with id
            let _ = SessionAdapter.fetch(sessionID: id).then { response-> Void in

                SVProgressHUD.dismiss()
                
                /// Safety check
                guard let response = response else {
                    return
                }
                
                /// Transition to create new session report
                let createVC = ScheduleRouteHandler.createSessionReportTransition(session: response)
                createVC.1.onFlowCompleted({ session in
                    
                    /// Safety check
                    guard let session = session else {
                        return
                    }
                    
                    let title = session.student?.firstName != nil ? "Session report for \(session.student!.firstName!) added successfully" : "Session report added successfully"
                    DefaultNotificationView.showNotification(controller: self, title: title, image: #imageLiteral(resourceName: "schedule_navigation_icon"))
                })
                
                self.presentVC(createVC.0)
            }
            
        case .learningPlan:
            
            /// Safety check
            guard let id = id else {
                return
            }
            
            SVProgressHUD.show()
            
            /// Fetch student with id
            let _ = StudentAdapter.fetch(studentID: id).then { response-> Void in

                SVProgressHUD.dismiss()
                
                /// Safety check
                guard let response = response else {
                    return
                }
                
                /// Transition to create new learning plan
                let createVC = ClientsRouteHandler.createLearningPlanTransition(student: response)
                createVC.1.onFlowCompleted({ learningPlan in
                    /// Safety check
                    guard let learningPlan = learningPlan else {
                        return
                    }
                    
                    let title = learningPlan.student?.firstName != nil ? "Learning plan for \(learningPlan.student!.firstName!) addedd successfully" : "Learning plan added successfully"
                    DefaultNotificationView.showNotification(controller: self, title: title, image: #imageLiteral(resourceName: "client_navigation_icon"))
                })
                
                self.presentVC(createVC.0)
            }
        }
    }
    
    /// Card tapped
    func cardTapped(type: CardCompletedType, id: String) {
        
        switch type {
        case .student, .learningPlan:
            
            /// Fetch student details + transition
            ClientsRouteHandler.clientTransition(studentID: id).then { response-> Void in
                
                /// Safety check
                guard let response = response else {
                    return
                }
                
                /// Present
                self.presentVC(response)
                }.catch { error in
                    print(error)
            }
        case .session, .sessionReport:
            
            ScheduleRouteHandler.scheduleTransition(sessionID: id).then { response-> Void in
                
                /// Safety check
                guard let response = response else {
                    return
                }
                
                /// Present
                self.presentVC(response)
                }.catch { error in
                    print(error)
            }
        default: break
        }
    }
    
    /// Images selection
    func imagesSelected(_ images: [URL]) {
        
        /// Building images
        let result = images.map { SKPhoto.photoWithImageURL($0.absoluteString) }
        
        /// Create photoBrowser
        let browser = SKPhotoBrowser(photos: result)
        browser.initializePageIndex(0)
        presentVC(browser)
    }
    
    /// Editing started
    func formInputEditingStarted(_ node: FormInputContentNode) {
        print("Started")
    }
    
    func formInputEditingEnded(_ node: FormInputContentNode) {
        print("Ended")
    }
    
    /// Called when form input done pressed
    ///
    /// - Parameters:
    ///   - formInput: form input object
    ///   - message: message object
    func formInputDonePressed(_ formInput: FormInputContentNode, message: Message) {
        
        /// Safety check
        let formInputs = formInput.formInputs
        
        /// Validate forms
        /// Go through forms
        for form in formInputs.datasource {
            /// Validation checks
            if let textForm = form as? FormTextInput, textForm.value.length == 0 {
                print("EMPTY fields")
                return
            }
            
            /// Validate with rules
            for validationRule in form.formInputValidation {
                
                if !validationRule.validate(form.value) {
                    /// Not valid, show error
                    print("ERROR DURING VALIDATION")
                    return
                }
            }
        }
        
        /// Validation successful
        /// Go through form input types
        switch formInputs.type {
        case .simple, .custom:
            
            /// Check if need to use stripe form updates
            guard let _ = message.stripeInfo, let stripeModel = formInputs.stripeModel else {
                /// Handle simple forms
                handleSimpleForm(formInputs: formInputs, message: message, node: formInput)
                return
            }
            
            /// Handle payment
            handlePaymentForm(message: message, formInputs: formInputs, stripeModel: stripeModel, node: formInput)
            
        default:
            print("Other")
        }
    }
    
    /// Handle simple form udpates
    ///
    /// - Parameters:
    ///   - formInputs: form inputs params
    ///   - message: message
    private func handleSimpleForm(formInputs: FormInputs, message: Message, node: FormInputContentNode) {
        
        /// Update input forms
        message.attributes[FormInputsJSON.inputs] = formInputs.attributes
        
        /// Twillio Message attributes
        var updatedMessageAttributes: [String: Any] = [:]
        
        /// Update message attributes
        var messageAttributes = message.attributes
        messageAttributes[MessageJSON.typeString] = "form_input"
        messageAttributes.removeValue(forKey: MessageJSON.responseAttributes)
        
        /// Update attributes
        updatedMessageAttributes.combine(messageAttributes)
        updatedMessageAttributes.combine(["tempId": UUID().uuidString])
        updatedMessageAttributes.combine(["device_data": globalAttributes, "version": ez.appVersion!])
        
        /// Form is ready for backend
        updatedMessageAttributes.combine(["form_is_ready_for_submission": true])
        
        /// Update form state
        updatedMessageAttributes.combine([FormInputsJSON.state: FormState.submitting.rawValue])
        
        SVProgressHUD.show()
        let messageIndex: NSNumber = message.twilioMessageIndex ?? 0
        channel?.fetchMessage(messageIndex: messageIndex).then { twilioMessage, message-> Promise<TCHResult> in
            
            return twilioMessage.updateAttributes(updatedMessageAttributes)
            }.then { response-> Promise<(TCHMessage, Message?)> in
                
                /// Update node
                Analytics.trackEventWithID(.s3_6, eventParams: ["type": message.type.rawValue, "timestamp": message.sent?.toString() ?? "", "success": response.isSuccessful()])
                
                return self.channel!.fetchMessage(messageIndex: messageIndex)
            }.then { (twilioMessage, message)-> Void in
                
                SVProgressHUD.dismiss()
                
                guard let message = message else {
                    return
                }
                
                /// Update temp state
                message.attributes[FormInputsJSON.state] = FormState.submitted.rawValue
                message.formInputs?.state = FormState.submitted
                
                /// Update node
                node.message = message
                
                /// Show typing indicator
                self.showTypingIndicator()
                
            }.catch { error in
                SVProgressHUD.dismiss()
                
                Analytics.trackEventWithID(.s3_6, eventParams: ["type": message.type.rawValue, "timestamp": message.sent?.toString() ?? "", "success": "false"])
                BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .form)
        }
    }
    
    /// Handle stripe call to add payment
    ///
    /// - Parameters:
    ///   - message: messages associated with stripe info
    ///   - formInputs: inputs object
    ///   - stripeModel: stripe model from inputs
    ///   - node: node from chat
    private func handlePaymentForm(message: Message, formInputs: FormInputs, stripeModel: StripeModel, node: FormInputContentNode) {
        
        PaymentAdapter.stripeToken(accountNumber: stripeModel.accountNumber, routingNumber: stripeModel.routingNumber, stripeInfo: message.stripeInfo!).then { response-> Promise<(TCHMessage, Message?)> in
            
            /// Update input forms
            message.attributes[FormInputsJSON.inputs] = formInputs.attributes
            
            /// Update stripe data
            var stripeAttributes = message.stripeInfo?.attributes ?? [:]
            stripeAttributes[StripeInfoJSON.token] = response.tokenId
            
            /// Twillio Message attributes
            var updatedMessageAttributes = globalAttributes
            
            /// Hide account #
            var inputsCopy: [[String: Any]] = []
            if let inputsArray = message.attributes[AttributeType.formInput.rawValue] as? [[String: Any]] {
                /// Enumerate
                for var input in inputsArray {
                    if let displayName = input[FormTextInputJSON.displayName] as? String, displayName.lowercased() == "account #", let value = input[FormInputJSON.value] as? String {
                        
                        input[FormInputJSON.value] = "XXXXXXX\(value.substring(with: value.length-4..<value.length))"
                    }
                    
                    /// Safety check
                    if input.count > 0 {
                        inputsCopy.append(input)
                    }
                }
            }
            message.attributes[AttributeType.formInput.rawValue] = inputsCopy
            
            /// Update message attributes
            var messageAttributes = message.attributes
            messageAttributes[MessageJSON.typeString] = "form_input"
            messageAttributes[MessageJSON.stripeMetadata] = stripeAttributes
            
            messageAttributes.removeValue(forKey: MessageJSON.responseAttributes)
            
            /// Update attributes
            updatedMessageAttributes.combine(messageAttributes)
            updatedMessageAttributes.combine(["tempId": UUID().uuidString])
            
            /// Form is ready for backend
            updatedMessageAttributes.combine(["form_is_ready_for_submission": true])
            
            /// Update form state
            updatedMessageAttributes.combine([FormInputsJSON.state: FormState.submitting.rawValue])
            
            SVProgressHUD.show()
            
            let messageIndex: NSNumber = message.twilioMessageIndex ?? 0
            return self.channel!.fetchMessage(messageIndex: messageIndex).then { (twilioMessage, message)-> Promise<TCHResult> in
                
                return twilioMessage.updateAttributes(updatedMessageAttributes)
                }.then { response-> Promise<(TCHMessage, Message?)> in
                    
                    /// Update node
                    Analytics.trackEventWithID(.s3_6, eventParams: ["type": "payment", "timestamp": Date().toString(), "success": "true"])
                    
                    return self.channel!.fetchMessage(messageIndex: messageIndex)
                }.then { (twilioMessage, message)-> (TCHMessage, Message?) in
                    
                    SVProgressHUD.dismiss()
                    
                    guard let _message = message else {
                        return (twilioMessage, message)
                    }
                    
                    /// Update temp state
                    _message.attributes[FormInputsJSON.state] = FormState.submitted.rawValue
                    _message.formInputs?.state = FormState.submitted
                    
                    /// Update node
                    node.message = _message
                    return (twilioMessage, _message)
            }
            }.catch { error in
                SVProgressHUD.dismiss()
                
                Analytics.trackEventWithID(.s3_6, eventParams: ["type": "payment", "timestamp": Date().toString(), "success": "false"])
                
                BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .stripe)
        }
    }
}
