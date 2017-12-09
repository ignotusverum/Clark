//
//  RadioButtonInput.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/17/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON

class RadioButtonInput: FormInputProtocol {
    
    /// Validation
    var formInputValidation: [FormInputValidation]
    
    /// Type
    var type: FormInputType = .switchButton
    
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
        result[FormInputJSON.value] = "Yes"
        
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
    }
}
