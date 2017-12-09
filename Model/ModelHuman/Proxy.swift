//
//  Proxy.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

/// Struct that represent Proxy JSON keys
public struct ProxyJSON {

	static let email = "email"
	static let firstName = "first_name"
	static let lastName = "last_name"
	static let phone = "phone"
}

@objc(Proxy)
open class Proxy: _Proxy {

    /// Full name
    var fullName: String {
        
        var fullNameString = firstName ?? ""
        
        if let _lastName = lastName {
            
            let additionalSpace = firstName != nil ? " " : ""
            fullNameString = fullNameString + additionalSpace + _lastName
        }
        
        return fullNameString
    }
    
    /// Model update logic
    override func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {
        
        try super.updateModel(with: source, transaction: transaction)
        
        /// Safety check for attributes
        guard let attributesJSON = source[ModelJSON.attributes].json else {
            return
        }
        
        /// Emails
        email = attributesJSON[ProxyJSON.email].string
        
        /// Phone
        phone = attributesJSON[ProxyJSON.phone].string
        
        /// First name
        firstName = attributesJSON[ProxyJSON.firstName].string
        
        /// First name
        lastName = attributesJSON[ProxyJSON.lastName].string
    }
}
