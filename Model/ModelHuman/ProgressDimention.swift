//
//  ProgreeDimention.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

/// Struct that represent ProgreeDimention JSON keys
public struct ProgressDimentionJSON {

    static let name = "name"
	static let category = "category"
	static let dimentionDescription = "descriptions"
}

@objc(ProgressDimention)
open class ProgressDimention: _ProgressDimention {

    /// Dimentions
    var descriptions: [String] {
        return dimentionDescription as? [String] ?? []
    }
    
    /// Model update logic
    override func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {
        
        try super.updateModel(with: source, transaction: transaction)
        
        /// Safety check for attributes
        guard let attributesJSON = source[ModelJSON.attributes].json else {
            return
        }
        
        /// Name
        name = attributesJSON[ProgressDimentionJSON.name].string ?? ""
        
        /// Category
        category = attributesJSON[ProgressDimentionJSON.category].string ?? ""
        
        /// Descriptions
        dimentionDescription = attributesJSON[ProgressDimentionJSON.dimentionDescription].arrayObject as? [String] ?? []
    }
}
