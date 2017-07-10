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
    case allCharacters = "all_letters"
}

class FormTextInput: FormInputProtocol {
    
    /// Type
    var type: FormInputType = .text
    
    /// Value
    var value: String
    
    /// Placeholder
    var displayName: String
    
    /// Autocomplete
    var isAutocompleteEnabled: Bool
    
    /// Keyboard type
    var keyboardType: UIKeyboardType = .default
    
    /// Capitalization type
    var capitalizationType: UITextAutocapitalizationType = .none
    
    // MARK: - Initialization
    required init(source: JSON) {
        
        /// Value
        self.value = source[FormInputJSON.value].string ?? ""
        
        /// Display name
        self.displayName = source[FormTextInputJSON.displayName].string ?? ""
        
        /// Autocomplete
        self.isAutocompleteEnabled = source[FormTextInputJSON.autocomplete].bool ?? false
        
        /// Keyboard type
        let keyboardTypeString = source[FormTextInputJSON.keyboardType].string ?? ""
        if let tempKeyboardType = InputKeyboardType(rawValue: keyboardTypeString) {
            switch tempKeyboardType {
            case .email:
                
                self.keyboardType = .emailAddress
            case .phonePad:
                
                self.keyboardType = .phonePad
            case .numberPad:
                
                self.keyboardType = .numberPad
            }
        }
        
        /// Capitalization
        let capitalizationTypeString = source[FormTextInputJSON.capitalizationRule].string ?? ""
        if let tempCapitalizationType = InputCapitalizationType(rawValue: capitalizationTypeString) {
            switch tempCapitalizationType {
            case .none:
                
                self.capitalizationType = .none
            case .allWorlds:
                
                self.capitalizationType = .words
            case .allCharacters:
                
                self.capitalizationType = .allCharacters
            }
        }
    }
}
