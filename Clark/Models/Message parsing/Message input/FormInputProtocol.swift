//
//  FormInputProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/10/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

/// Form states
enum FormState: String {
    
    case submitted = "submitted"
    case hasErrors = "has_errors"
    case unsubmitted = "unsubmitted"
    case invalidated = "invalidated"
}

/// Input types
enum FormInputType: String {
    
    case text = "text"
    case secret = "secret"
    case slider = "slider"
    case switchButton = "radio_switch"
    case checkmarkButton = "radio_button"
}

/// Form Types
enum FormType: String {
    
    case login = "login"
    case signup = "signup"
    case simple = "simple"
    case custom = "custom"
}

protocol FormInputProtocol {
    
    /// Type
    var type: FormInputType { get set }
    
    /// Value
    var value: String { get set }
    
    /// Placeholder
    var displayName: String { get set }
}
