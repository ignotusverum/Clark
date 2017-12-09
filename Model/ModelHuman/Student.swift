//
//  Student.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

/// Struct that represent Student JSON keys
public struct StudentJSON {
    
    static let lastName = "last_name"
    static let firstName = "first_name"
    
    static let email = "email"
    
    static let age = "age"
    static let gender = "gender"
    
    static let status = "status"
    
    static let phone = "phone"
    
    static let nextUpcomingSessionDate = "next_upcoming_session_date"
    
    static let defaultHourlyRateInCents = "default_hourly_rate_in_cents"
    static let cancellationWindowInHours = "cancellation_window_in_hours"
    static let cancellationPercentageCharged = "cancellation_percentage_charged"
    static let defaultSessionLengthInMinutes = "default_session_length_in_minutes"
    
    static let session = "next_upcoming_session"
    static let learningPlan = "active_learning_plan"
    static let subjects = "subjects"
    
    static let proxy = "primary_proxy"
    
    static let cancelation = "cancellation_policy_name"
}

enum CancelationType: String {
    
    case flexible = "flexible"
    case moderate
    case strict
    
    func generateTitle()-> String {
        switch self {
        case .flexible:
            return "Flexible"
        case .moderate:
            return "Moderate"
        case .strict:
            return "Strict"
        }
    }
    
    func generateDescription()-> String {
        switch self {
        case .flexible:
            return "Client receives a 100% refund when cancelling with less than 24 hours notice"
        case .moderate:
            return "Client receives a 50% refund if cancelling with less than 24 hours notice"
        case .strict:
            return "Client receives no refund for cancellations made within the 24hr window"
        }
    }
}

@objc(Student)
open class Student: _Student {
    
    /// Subjects array
    var subjectsArray: [Subject] {
        return subjects.allObjects as? [Subject] ?? []
    }
    
    /// Learning plans array
    var learningPlansArray: [LearningPlan] {
        return learningPlans.allObjects as? [LearningPlan] ?? []
    }
    
    /// Autocomplete setup
    public static var autocompleteKey: String = "student_names"
    public var body: String {
        return fullName ?? ""
    }
    
    /// Fee string
    var feeString: String {
        return "$\(fee)"
    }
    
    /// Canceltion type
    var cancelationType: CancelationType {
        return CancelationType(rawValue: cancelationTypeString ?? "") ?? .flexible
    }
    
    var fee: Int {
        return (defaultHourlyRateInCents?.intValue ?? 0) / 100
    }
    
    /// Learning plan array
    var learningPlanArray: [LearningPlan] {
        return learningPlans.allObjects as? [LearningPlan] ?? []
    }
    
    // First name initials getter
    var firstNameInitial: String {
        
        guard var firstName = self.firstName else {
            return ""
        }
        
        firstName.capitalizeFirst()
        
        return firstName[0].toString
    }
    
    // Last name initials getter
    var lastNameInitial: String {
        
        guard var lastName = self.lastName else {
            return ""
        }
        
        lastName.capitalizeFirst()
        
        return lastName[0].toString
    }
    
    /// Initials
    var initials: String {
        return firstNameInitial + lastNameInitial
    }
    
    /// Session array
    var sessionsArray: [Session] {
        return sessions.allObjects as! [Session]
    }
    
    /// Model update logic
    override func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {
        
        try super.updateModel(with: source, transaction: transaction)
        
        /// Relationships
        if let relationShipsJSON = source[ModelJSON.relationShips].json {
            
            /// Parse through relations
            /// Get proxy information
            if let proxyJSON = relationShipsJSON[StudentJSON.proxy].json, let dataJSON = proxyJSON[ModelJSON.data].array?.first ?? proxyJSON[ModelJSON.data].json {
                /// Update student relation
                if let proxy = try transaction.importUniqueObject(Into<Proxy>(), source: dataJSON) {
                    self.proxy = proxy
                }
            }
            
            /// Parse through relations
            /// Get session information
            if let sessionJSON = relationShipsJSON[StudentJSON.session].json, let dataJSON = sessionJSON[ModelJSON.data].json ?? sessionJSON[ModelJSON.data].array?.first {
                /// Update student relation
                if let session = try transaction.importUniqueObject(Into<Session>(), source: dataJSON) {
                    addSessionsObject(session)
                    closestSession = session
                }
            }
            
            /// Get learning plan info
            if let learningPlanJSON = relationShipsJSON[StudentJSON.learningPlan].json, let dataJSON = learningPlanJSON[ModelJSON.data].json ?? learningPlanJSON[ModelJSON.data].array?.first {
                /// Update learning plan relation
                if let learningPlan = try transaction.importUniqueObject(Into<LearningPlan>(), source: dataJSON) {
                    addLearningPlansObject(learningPlan)
                }
            }
            
            /// Subjects plan info
            if let subjectJSON = relationShipsJSON[StudentJSON.subjects].json, let dataJSON = subjectJSON[ModelJSON.data].json ?? subjectJSON[ModelJSON.data].array?.first {
                /// Update subjects relation
                if let subject = try transaction.importUniqueObject(Into<Subject>(), source: dataJSON) {
                    addSubjectsObject(subject)
                }
            }
        }
        
        /// Safety check for attributes
        guard let attributesJSON = source[ModelJSON.attributes].json else {
            return
        }
        
        /// First Name
        firstName = attributesJSON[StudentJSON.firstName].string
        
        /// Last name
        lastName = attributesJSON[StudentJSON.lastName].string
        
        var fullNameString = firstName ?? ""
        if let _lastName = lastName {
            
            let additionalSpace = firstName != nil ? " " : ""
            fullNameString = fullNameString + additionalSpace + _lastName
        }
        
        fullName = fullNameString
        
        /// Email
        email = attributesJSON[StudentJSON.email].string
        
        /// Gender
        gender = attributesJSON[StudentJSON.gender].string
        
        /// Age
        age = attributesJSON[StudentJSON.age].number
        
        /// Cancelation
        cancelationTypeString = attributesJSON[StudentJSON.cancelation].string
        
        /// Status
        status = attributesJSON[StudentJSON.status].string
        
        /// Phone
        phone = attributesJSON[StudentJSON.phone].string
        
        /// Cancellation persentage
        cancellationPercentageCharged = attributesJSON[StudentJSON.cancellationPercentageCharged].number ?? 0
        
        /// Cancellation window in hrs
        cancellationWindowInHours = attributesJSON[StudentJSON.cancellationWindowInHours].number ?? 0
        
        /// Default hourly rate
        defaultHourlyRateInCents = attributesJSON[StudentJSON.defaultHourlyRateInCents].number ?? 0
        
        print(defaultHourlyRateInCents)
        
        /// Session lenght in mins
        defaultSessionLengthInMinutes = attributesJSON[StudentJSON.defaultSessionLengthInMinutes].number ?? 0
        
        /// Upcoming session date
        nextUpcomingSessionDate = attributesJSON[StudentJSON.nextUpcomingSessionDate].dateTime
    }
}

extension Student: AutocompleteCategory {
    
    public static func valuesContaining(searchString: String) -> [AutocompleteCategory] {
        
        var result: [AutocompleteCategory]?
        if searchString.length == 0 {
            result = DatabaseManager.defaultStack.fetchAll(From<Student>(), OrderBy(.ascending("\(StudentAttributes.fullName.rawValue)")))
        }
        else {
            
            result = DatabaseManager.defaultStack.fetchAll(From<Student>(), Where("\(StudentAttributes.fullName.rawValue) BEGINSWITH[cd] %@ || \(StudentAttributes.firstName.rawValue) BEGINSWITH[cd] %@ || \(StudentAttributes.lastName.rawValue) BEGINSWITH[cd] %@", searchString, searchString, searchString), OrderBy(.ascending("\(StudentAttributes.fullName.rawValue)")))
        }
        
        return result ?? []
    }
    
    public static func valuesContainingIn(searchString: String) -> [AutocompleteCategory] {
        
        var result: [AutocompleteCategory]?
        if searchString.length == 0 {
            result = DatabaseManager.defaultStack.fetchAll(From<Student>(), OrderBy(.ascending("\(StudentAttributes.fullName.rawValue)")))
        }
        else {
            
            result = DatabaseManager.defaultStack.fetchAll(From<Student>(), Where("\(StudentAttributes.fullName.rawValue) CONTAINS[cd] %@ || \(StudentAttributes.firstName.rawValue) CONTAINS[cd] %@ || \(StudentAttributes.lastName.rawValue) CONTAINS[cd] %@", searchString, searchString, searchString), OrderBy(.ascending("\(StudentAttributes.fullName.rawValue)")))
        }
        
        return result ?? []
    }
}

