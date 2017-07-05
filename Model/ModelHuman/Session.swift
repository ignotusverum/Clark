//
//  Session.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

/// Struct that represent Session JSON keys
public struct SessionJSON {

    static let endTime = "endTime"
    static let startTime = "startTime"
    static let durationInMinutes = "durationInMinutes"
    
    static let location = "location"
    static let feeInCents = "feeInCents"
    static let statusString = "statusString"
    static let feedbackReportBody = "feedbackReportBody"
    
    static let student = "student"
}

/// Session status
public enum SessionStatus:String {
    case paid = "paid"
    case pending = "pending"
    case cancelled = "cancelled"
    case confirmed = "confirmed"
    case rescheduled = "rescheduled"
    case paymentDeclined = "payment_declined"
}

@objc(Session)
open class Session: _Session {

    /// Status representation
    public var status: SessionStatus {
        return SessionStatus(rawValue: statusString!)!
    }
    
    /// Session feedback
    public var hasSessionFeedbackReport: Bool {
        if let feedbackReport = feedbackReportBody, feedbackReport.characters.count > 0 {
            return true
        }
        
        return false
    }
    
    /// Autocomplete Key
    public static var autocompleteKey: String = "sessions"
    
	/// Model update logic
    override func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {

        try super.updateModel(with: source, transaction: transaction)

        /// Relationships
        if let relationShipsJSON = source[ModelJSON.relationShips].json {
            
            /// Parse through relations
            /// Get student information
            if let studentJSON = relationShipsJSON[SessionJSON.student].json, let dataJSON = studentJSON[ModelJSON.data].json {
                /// Update student relation
                student = try transaction.importUniqueObject(Into<Student>(), source: dataJSON)
            }
        }
        
        /// Safety check for attributes
        guard let attributesJSON = source[ModelJSON.attributes].json else {
            return
        }
        
        /// End time
        endTime = attributesJSON[SessionJSON.endTime].dateTime
        
        /// Start time
        startTime = attributesJSON[SessionJSON.startTime].dateTime
        
        /// Duration in mins
        durationInMinutes = attributesJSON[SessionJSON.durationInMinutes].number
        
        /// Location
        location = attributesJSON[SessionJSON.location].string
        
        /// Fee
        feeInCents = attributesJSON[SessionJSON.feeInCents].number
        
        /// Status string
        statusString = attributesJSON[SessionJSON.statusString].string
        
        /// Feedback Report
        feedbackReportBody = attributesJSON[SessionJSON.feedbackReportBody].string
    }
}
