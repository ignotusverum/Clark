//
//  BackgroundCheckPermissions.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 10/20/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON

public struct BackgroundCheckPermissionsJSON {
    
    static let fee = "fee_in_cents"
}

class BackgroundCheckPermissions: Permission {
    
    /// Internal check
    var fee: Int
    
    /// Initialization
    override init?(source: JSON?) {
        
        /// Safety check
        guard let source = source else {
            return nil
        }
        
        self.fee = source[BackgroundCheckPermissionsJSON.fee].int ?? 0
        
        super.init(source: source)
    }
}
