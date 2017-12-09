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
    
    static let endTime = "end_time"
    static let startTime = "start_time"
    static let durationInMinutes = "duration_in_minutes"
    
    static let location = "location"
    static let statusString = "status"
    
    static let feeInCents = "fee_in_cents"
    
    static let feedbackBody = "feedback_report_body"
    static let feedbackRating = "feedback_report_rating"
    static let feedbackPositive = "feedback_report_positive_notes"
    static let feedbackNegative = "feedback_report_negative_notes"
    
    static let reminders = "do_session_reminders"
    
    static let student = "student"
    static let sessionReport = "session_reports"
}

/// Session status
public enum SessionStatus: String {
    case paid = "paid"
    case pending = "pending"
    case cancelled = "cancelled"
    case confirmed = "confirmed"
    case rescheduled = "rescheduled"
    case paymentDeclined = "payment_declined"
    
    static let colors: [SessionStatus: UIColor] = [.paid : UIColor.payedStatusColor, .pending: UIColor.pendingStatusColor, .cancelled: UIColor.inActiveStateColor, .confirmed: UIColor.payedStatusColor, .rescheduled: UIColor.pendingStatusColor, .paymentDeclined: UIColor.inActiveStateColor]
}

@objc(Session)
open class Session: _Session {
    
    /// Fee string
    var feeString: String {
        return "$\(fee)"
    }
    
    var fee: Int {
        return (feeInCents?.intValue ?? 0) / 100
    }
    
    var durationCopy: String {
        
        let duration = ((durationInMinutes?.doubleValue ?? 0) / Double(60)).rounded(toPlaces: 2)
        if duration < 1 {
            return "\(Int(duration * 100)) minutes"
        }
        
        return "\(duration) hours"
    }
    
    /// Autocomplete setup
    public static var autocompleteKey: String = "sessions"
    public var body: String {
        return student?.fullName ?? ""
    }
    
    /// Status representation
    public var status: SessionStatus {
        return SessionStatus(rawValue: statusString!)!
    }
    
    /// Header order
    var headerString: String? {
        return startTime?.toString(format: "MMM")
    }
    
    /// Session feedback
    var hasSessionFeedbackReport: Bool {
        return sessionReport != nil
    }
    
    /// Positive
    var hasFeedbackPositive: Bool {
        return (sessionReport?.positiveNotes ?? "").length > 0
    }
    
    /// Negative
    var hasFeedbackNegative: Bool {
        return (sessionReport?.negativeNotes ?? "").length > 0
    }
    
    func localStartTime(format: String = "E, d MMM HH:mm a")-> String? {
        return Date.localDateString(startTime, format: format)
    }
    
    func localEndTime(format: String = "E, d MMM HH:mm a")-> String? {
        return Date.localDateString(endTime, format: format)
    }
    
    // MARK: - Utilities
    class func findClosesSession(list: [Session], iteration: Int = 1)-> Session? {
        
        /// Start
        let startDate = Calendar.current.date(byAdding: .day, value: iteration, to: Date()) ?? Date()
        let endDate = Calendar.current.date(byAdding: .day, value: -iteration, to: Date()) ?? Date()
        
        let session = DatabaseManager.defaultStack.fetchOne(From<Session>(), Where("\(SessionAttributes.startTime.rawValue) <= %@ AND \(SessionAttributes.startTime.rawValue) >= %@", startDate, endDate))
        
        if iteration == 20 {
            return list.first
        }
        
        if let session = session {
            return session
        }
        else {
            return findClosesSession(list: list, iteration: iteration+1)
        }
    }
    
    /// Model update logic
    override func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {
    
        try super.updateModel(with: source, transaction: transaction)
        
        /// Relationships
        if let relationShipsJSON = source[ModelJSON.relationShips].json {
            
            /// Parse through relations
            /// Get student information
            if let studentJSON = relationShipsJSON[SessionJSON.student].json, let dataJSON = studentJSON[ModelJSON.data].array?.first ?? studentJSON[ModelJSON.data].json {
                /// Update student relation
                student = try transaction.importUniqueObject(Into<Student>(), source: dataJSON)
            }
            
            /// Get session reports
            if let sessionReportJSON = relationShipsJSON[SessionJSON.sessionReport].json, let dataJSON = sessionReportJSON[ModelJSON.data].array?.first ?? sessionReportJSON[ModelJSON.data].json {
                /// Update session relation
                sessionReport = try transaction.importUniqueObject(Into<SessionReport>(), source: dataJSON)
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
        
        /// Ordering date
        if let startTime = startTime {
            
            let calendar = Calendar(identifier: .gregorian)
            
            let comp = calendar.dateComponents([.month, .year], from: startTime)
            
            orderingDate = calendar.date(from: comp)
        }
        
        /// Student details ordering
        studentDetailsOrdering = NSNumber(value: !(startTime?.isPast ?? false))
        
        /// Duration in mins
        durationInMinutes = attributesJSON[SessionJSON.durationInMinutes].number ?? 0
        
        /// Location
        location = attributesJSON[SessionJSON.location].string
        
        /// Fee
        feeInCents = attributesJSON[SessionJSON.feeInCents].number ?? 0
        
        /// Status string
        statusString = attributesJSON[SessionJSON.statusString].string
        
        /// Feedback Report
        feedbackBody = attributesJSON[SessionJSON.feedbackBody].string
        
        /// Feedback rating
        feedbackRating = attributesJSON[SessionJSON.feedbackRating].string
        
        /// Feedback positive
        feedbackPositive = attributesJSON[SessionJSON.feedbackPositive].string
        
        /// Feedback negative
        feedbackNegative = attributesJSON[SessionJSON.feedbackNegative].string
    
        /// Reminders
        isRemindersOn = attributesJSON[SessionJSON.reminders].number
    }
}

extension Session: AutocompleteCategory {
    
    public static func valuesContaining(searchString: String) -> [AutocompleteCategory] {
        
        let studentPreticate = ("\(SessionRelationships.student.rawValue)")
        
        var result: [AutocompleteCategory]?
        if searchString.length == 0 {
            result = DatabaseManager.defaultStack.fetchAll(From<Session>(), OrderBy(.ascending("\(studentPreticate).\(StudentAttributes.fullName.rawValue)")))
        }
        else {
            
            result = DatabaseManager.defaultStack.fetchAll(From<Session>(), Where("\(studentPreticate).\(StudentAttributes.firstName.rawValue) BEGINSWITH[cd] %@ || \(studentPreticate).\(StudentAttributes.lastName.rawValue) BEGINSWITH[cd] %@ || \(studentPreticate).\(StudentAttributes.fullName.rawValue) BEGINSWITH[cd] %@", searchString, searchString, searchString), OrderBy(.ascending("\(studentPreticate).\(StudentAttributes.fullName.rawValue)")))
        }
        
        return result ?? []
    }
    
    public static func valuesContainingIn(searchString: String) -> [AutocompleteCategory] {
        
        let studentPreticate = ("\(SessionRelationships.student.rawValue)")
        
        var result: [AutocompleteCategory]?
        if searchString.length == 0 {
            result = DatabaseManager.defaultStack.fetchAll(From<Session>(), OrderBy(.ascending("\(studentPreticate).\(StudentAttributes.fullName.rawValue)")))
        }
        else {
            
            result = DatabaseManager.defaultStack.fetchAll(From<Session>(), Where("\(studentPreticate).\(StudentAttributes.firstName.rawValue) CONTAINS[cd] %@ || \(studentPreticate).\(StudentAttributes.lastName.rawValue) CONTAINS[cd] %@ || \(studentPreticate).\(StudentAttributes.fullName.rawValue) CONTAINS[cd] %@", searchString, searchString, searchString), OrderBy(.ascending("\(studentPreticate).\(StudentAttributes.fullName.rawValue)")))
        }
        
        return result ?? []
    }
}
