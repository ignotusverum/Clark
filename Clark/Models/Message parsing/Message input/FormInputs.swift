//
//  FormInputs.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON
import Foundation

struct FormInputsJSON {
    
    static let header = "form_title"
    static let subHeader = "form_subtitle"
    
    static let state = "form_state"
    static let inputs = "form_inputs"
    
    static let type = "form_type"
    static let id = "form_id"
}

/// Form states
enum FormState: String {
    
    case submitted = "submitted"
    case submitting = "submitting"
    case hasErrors = "has_errors"
    case unsubmitted = "unsubmitted"
    case invalidated = "invalidated"
}

/// Form Types
enum FormType: String {
    
    case login = "login"
    case signup = "signup"
    case simple = "simple"
    case custom = "custom"
}

/// Login model
struct LoginModel {
    
    var email: String
    var password: String
}

/// Stripe model
struct StripeModel {
    
    var accountNumber: String
    var routingNumber: String
}

class FormInputs {
    
    /// ID
    var id: String?
    
    /// Form header
    var header: String?
    
    /// Form subheader
    var subHeader: String?
    
    /// Type
    var type: FormType
    
    /// State
    var state: FormState
    
    /// Stripe model
    var stripeModel: StripeModel? {
        
        var accountNumber = ""
        var routingNumber = ""
        
        for formInput in datasource {
            
            if formInput.displayName.lowercased() == "routing #" {
                routingNumber = formInput.value
            }
            
            if formInput.displayName.lowercased() == "account #" {
                accountNumber = formInput.value
            }
        }
        
        return accountNumber.length > 0 && routingNumber.length > 0 ? StripeModel(accountNumber: accountNumber, routingNumber: routingNumber) : nil
    }
    
    /// Login model
    var loginModel: LoginModel? {
        
        var email = ""
        var password = ""
        
        for formInput in datasource {
            
            if formInput.placeholder.lowercased() == "email" {
                email = formInput.value
            }
            
            if formInput.placeholder.lowercased() == "password" {
                password = formInput.value
            }
        }
        
        return email.length > 0 && password.length > 0 ? LoginModel(email: email, password: password) : nil
    }
    
    /// Form inputs datasource
    var datasource: [FormInputProtocol] = []
    var updatedDatasource: [FormInputProtocol] = []
    
    /// Static attributes
    var staticAttributes: [String: Any] = [:]
    
    /// Input attributes
    var attributes: [[String: Any]] {
        return datasource.map { $0.attributes }
    }
    
    init?(source: JSON?) {
        
        /// Safety check
        guard let source = source, let id = source[FormInputsJSON.id].string, let inputsJSON = source[FormInputsJSON.inputs].array else {
            return nil
        }
        
        /// ID
        self.id = id
        
        /// Static attributes
        staticAttributes = source.dictionaryObject ?? [:]
        
        /// Header
        self.header = source[FormInputsJSON.header].string
        
        /// Sub-header
        self.subHeader = source[FormInputsJSON.subHeader].string
        
        /// State
        let stateString = source[FormInputsJSON.state].string ?? ""
        self.state = FormState(rawValue: stateString) ?? .unsubmitted
        
        /// Type
        let typeString = source[FormInputsJSON.type].string ?? ""
        self.type = FormType(rawValue: typeString) ?? .simple
        
        /// Dafety cleaning
        self.datasource = []
        
        /// Inputs
        for inputJSON in inputsJSON {
            /// Checking if type exists
            if let typeString = inputJSON[FormInputJSON.type].string, let type = FormInputType(rawValue: typeString) {
                /// Creating type datasource
                switch type {
                /// Text input type
                case .text, .secret:
                    
                    let textInput = FormTextInput(source: inputJSON)
                    datasource.append(textInput)
                    updatedDatasource.append(textInput)
                    
                case .checkmarkButton:
                    
                    let buttonInput = RadioButtonInput(source: inputJSON)
                    datasource.append(buttonInput)
                    
                default:
                    print("not supported, yo - \(type.rawValue)")
                }
            }
        }
    }
}
