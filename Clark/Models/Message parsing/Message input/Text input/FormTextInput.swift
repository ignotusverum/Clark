//
//  FormTextInput.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/10/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

struct FormTextInputJSON {
    
    static let keyboardType = "default"
    static let placeholder = "placeholder"
    static let displayName = "display_name"
    static let autocomplete = "autocomplete"
    static let capitalizationRule = "keyboard_capitalization_rule"
}

/// Input keyboard type
enum InputKeyboardType: String {
    
    case email = "email"
    case phonePad = "phone_pad"
    case numberPad = "number_pad"
}

/// Input capitalization type
enum InputCapitalizationType: String {
    
    case none = "none"
    case allWorlds = "all_words"
    case firstWord = "first_word_only"
    case allCharacters = "all_letters"
}

class FormTextInput: FormInputProtocol {
    
    /// Validation
    var formInputValidation: [FormInputValidation]
    
    /// Type
    var type: FormInputType = .text
    
    /// Value
    var value: String
    
    /// Placeholder
    var placeholder: String
    
    /// Display name
    var displayName: String
    
    /// Autocomplete
    var isAutocompleteEnabled: Bool
    
    /// Keyboard type
    var keyboardType: UIKeyboardType = .default
    
    /// Capitalization type
    var capitalizationType: UITextAutocapitalizationType = .none
    
    /// Static attributes
    var staticAttributes: [String: Any] = [:]
    
    var attributes: [String: Any] {
        
        /// Static data + updates
        var result = staticAttributes
        
        /// Value
        result[FormInputJSON.value] = value
        
        return result
    }
    
    // MARK: - Initialization
    required init(source: JSON) {
        
        /// Static data
        staticAttributes = source.dictionaryObject ?? [:]
        
        /// Value
        self.value = source[FormInputJSON.value].string ?? ""
        
        /// Display name
        self.displayName = source[FormTextInputJSON.displayName].string ?? ""
        
        /// Placeholder
        self.placeholder = source[FormTextInputJSON.placeholder].string ?? ""
        
        /// Autocomplete
        self.isAutocompleteEnabled = source[FormTextInputJSON.autocomplete].bool ?? false
        
        /// Validation
        /// Temp validation array
        let validationErrorsArray = source[FormInputJSON.inputError].array ?? []
        
        /// Map & create validation rules
        self.formInputValidation = validationErrorsArray.flatMap { FormInputValidation(source: $0) }
        
        /// Keyboard type
        let keyboardTypeString = source[FormTextInputJSON.keyboardType].string ?? ""
        if let tempKeyboardType = InputKeyboardType(rawValue: keyboardTypeString) {
            switch tempKeyboardType {
            case .email:
                
                keyboardType = .emailAddress
            case .phonePad:
                
                keyboardType = .phonePad
            case .numberPad:
                
                keyboardType = .numberPad
            }
        }
        
        /// Capitalization
        let capitalizationTypeString = source[FormTextInputJSON.capitalizationRule].string ?? ""
        if let tempCapitalizationType = InputCapitalizationType(rawValue: capitalizationTypeString) {
            switch tempCapitalizationType {
            case .none:
                
                capitalizationType = .none
            case .allWorlds:
                
                capitalizationType = .words
            case .allCharacters:
                
                capitalizationType = .allCharacters
            default:
                capitalizationType = .sentences
            }
        }
    }
}
