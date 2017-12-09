//
//  Permission.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 10/20/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON

class Permission: PermissionsProtocol {
    
    /// Is permission enabled
    var isEnabled: Bool = true
    
    /// Attributes
    var attributes: JSON?
    
    /// Initialization
    init?(source: JSON?) {
        
        /// Safety check
        guard let source = source else {
            return nil
        }
        
        attributes = source
        isEnabled = source[PermissionsProtocolJSON.isEnabled].bool ?? true
    }
}

