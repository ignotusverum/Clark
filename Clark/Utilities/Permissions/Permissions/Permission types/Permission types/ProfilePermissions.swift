//
//  ProfilePermissions.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 10/20/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON

public struct ProfilePermissionsJSON {
    
    static let isInternalOnly = "internal_only"
}

class ProfilePermissions: Permission {

    /// Internal check
    var isInternalOnly: Bool
    
    /// Initialization
    override init?(source: JSON?) {
        
        /// Safety check
        guard let source = source else {
            return nil
        }
        
        self.isInternalOnly = source[ProfilePermissionsJSON.isInternalOnly].bool ?? false
        
        super.init(source: source)
    }
}

