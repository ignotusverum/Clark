//
//  FormInputError.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/13/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON
import Foundation

struct FormInputErrorJSON {
    
    static let type = "type"
    static let value = "value"
}

enum ValidationType: String {
    case maxLength = "max_length"
    case minLength = "min_length"
    case patternMatch = "pattern_match"
    case requiredLength = "required_length"
}

struct FormInputValidation {
    
    /// Input validation type
    var type: ValidationType
    
    /// Input validation value
    var value: String
    
    init?(source: JSON) {
     
        /// Safety check
        guard let typeString = source[FormInputErrorJSON.type].string, let type = ValidationType(rawValue: typeString), let value = source[FormInputErrorJSON.value].string else {
            return nil
        }
        
        self.type = type
        self.value = value
    }
    
    /// Validation
    func validate(_ response: String) -> Bool {
        switch type {
        case .maxLength:
            
            guard let valueInt = Int(value) else {
                return false
            }
            return response.length <= valueInt
        case .minLength:
            guard let valueInt = Int(value) else {
                return false
            }
            return response.length >= valueInt
        case .patternMatch:
            let predicate = NSPredicate(format:"SELF MATCHES %@", value)
            return predicate.evaluate(with: response)
        case .requiredLength:
            guard let valueInt = Int(value) else {
                return false
            }
            return response.length == valueInt
        }
    }
    
    /// Networking Request dict
    var attributes: [String: Any] {
        var dictionary: [String: Any] = [:]
        
        dictionary["value"] = self.value
        dictionary["type"] = self.type.rawValue
        
        return dictionary
    }
}
