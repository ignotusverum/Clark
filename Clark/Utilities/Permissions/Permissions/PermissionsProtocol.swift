//
//  PermissionsProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 10/20/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON

enum PermissionsProtocolJSON {
    static let isEnabled = "enabled"
    static let attributes = "attributes"
}

protocol PermissionsProtocol {
    
    /// Is permission enabled
    var isEnabled: Bool { get set }
    
    /// Attributes
    var attributes: JSON? { get set }
}
