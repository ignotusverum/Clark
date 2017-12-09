//
//  Subject.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

/// Struct that represent Subject JSON keys
public struct SubjectJSON {

    static let name = "name"
    static let typeString = "type"
	static let category = "category"
}

@objc(Subject)
open class Subject: _Subject {

    /// Model update logic
    override func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {
        
        try super.updateModel(with: source, transaction: transaction)
        
        /// Type
        typeString = source[SubjectJSON.typeString].string
        
        /// Attributes
        guard let attirubtesJSON = source["attributes"].json else {
            return
        }
        
        /// Name
        name = attirubtesJSON[SubjectJSON.name].string
        
        /// Category
        category = attirubtesJSON[SubjectJSON.category].string
    }
}
