//
//  SessionReport.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

/// Struct that represent SessionReport JSON keys
public struct SessionReportJSON {

	static let body = "body"
	static let rating = "rating"
    
    static let negativeNotes = "negative_notes"
    static let positiveNotes = "positive_notes"
}

@objc(SessionReport)
open class SessionReport: _SessionReport {

    /// dimentions
    var dimentions: [ProgressDimention] {
        return recursionDimentions.allObjects as? [ProgressDimention] ?? []
    }
    
    /// negative
    var nagativeDimention: [ProgressDimention] {
        return improvementDimentions.allObjects as? [ProgressDimention] ?? []
    }
    
    /// Model update logic
    override func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {
        
        try super.updateModel(with: source, transaction: transaction)
        
        /// Safety check for attributes
        guard let attributesJSON = source[ModelJSON.attributes].json else {
            return
        }
        
        /// Body
        body = attributesJSON[SessionReportJSON.body].string
        
        /// Rating
        rating = attributesJSON[SessionReportJSON.rating].string
        
        /// Negative notes
        negativeNotes = attributesJSON[SessionReportJSON.negativeNotes].string
        
        /// Positive notes
        positiveNotes = attributesJSON[SessionReportJSON.positiveNotes].string
    }
}
