//
//  FormInputProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/10/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

struct FormInputJSON {
    
    static let name = "name"
    static let type = "type"
    static let value = "value"
    static let inputError = "input_error"
}

/// Input types
enum FormInputType: String {
    
    case text = "text"
    case secret = "secret"
    case slider = "slider"
    case switchButton = "radio_switch"
    case checkmarkButton = "radio_button"
}

protocol FormInputProtocol {
    
    /// Type
    var type: FormInputType { get set }
    
    /// Atributes
    var attributes: [String: Any] { get }
    
    /// Static attributes
    var staticAttributes: [String: Any] { get set }
    
    /// Value
    var value: String { get set }
    
    /// Display name
    var displayName: String { get set }
    
    /// Placeholder
    var placeholder: String { get set }
    
    /// Validation
    var formInputValidation: [FormInputValidation] { get set }
    
    /// Initialization
    init(source: JSON)
}
