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
    
    static let header = "form_header"
    static let subHeader = "form_subheader"
    
    static let state = "form_state"
    static let inputs = "form_inputs"
    
    static let type = "form_type"
}

/// Form states
enum FormState: String {
    
    case submitted = "submitted"
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

class FormInputs {
    
    /// Form header
    var header: String?
    
    /// Form subheader
    var subHeader: String?
    
    /// Type
    var type: FormType
    
    /// State
    var state: FormState
    
    /// Form inputs datasource
    var datasource: [FormInputProtocol] = []
    
    init?(source: JSON?) {
        
        /// Safety check
        guard let source = source, source.count > 0 else {
            return nil
        }
        
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
        let inputsJSON = source[FormInputsJSON.inputs].array ?? []
        for inputJSON in inputsJSON {
            /// Checking if type exists
            if let typeString = inputJSON[FormInputJSON.type].string, let type = FormInputType(rawValue: typeString) {
                
                /// Creating type datasource
                switch type {
                /// Text input type
                case .text:
                    
                    let textInput = FormTextInput(source: inputJSON)
                    self.datasource.append(textInput)
                    
                default:
                    print("not supported, yo")
                }
            }
        }
    }
}
