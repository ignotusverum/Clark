//
//  StudentAddPermissions.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 10/20/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON

public struct StudentAddPermissionsJSON {
    
    static let isUnlimited = "unlimited"
}

class StudentAddPermissions: Permission {
    
    /// Internal check
    var isUnlimited: Bool
    
    /// Initialization
    override init?(source: JSON?) {
        
        /// Safety check
        guard let source = source else {
            return nil
        }
        
        self.isUnlimited = source[StudentAddPermissionsJSON.isUnlimited].bool ?? false
        
        super.init(source: source)
    }
}

