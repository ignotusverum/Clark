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

    static let lastName = "lastName"
    static let firstName = "firstName"
	
    static let email = "email"
    
    static let age = "age"
    static let gender = "gender"
    
    static let status = "status"

    static let phone = "phone"
    
    static let nextUpcomingSessionDate = "nextUpcomingSessionDate"
    
	static let defaultHourlyRateInCents = "defaultHourlyRateInCents"
    static let cancellationWindowInHours = "cancellationWindowInHours"
    static let cancellationPercentageCharged = "cancellationPercentageCharged"
	static let defaultSessionLengthInMinutes = "defaultSessionLengthInMinutes"
    
    static let session = "next_upcoming_session"
}

@objc(Student)
open class Student: _Student {

    // MARK: AutocompleteCategory properties
    public static var autocompleteKey: String = "student_names"
    public var body: String {
        if let first = firstName {
            if let last = lastName {
                return first + " " + last
            }
            return first
        }
        return ""
    }
    
    /// Full name
    var fullName: String {
        
        var fullNameString = firstName ?? ""
        
        if let _lastName = lastName {
            
            let additionalSpace = firstName != nil ? " " : ""
            fullNameString = fullNameString + additionalSpace + _lastName
        }
        
        return fullNameString
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
            /// Get session information
            if let sessionJSON = relationShipsJSON[StudentJSON.session].json, let dataJSON = sessionJSON[ModelJSON.data].json {
                /// Update student relation
                let session = try transaction.importUniqueObject(Into<Student>(), source: dataJSON)
                let tempSessionArray = session != nil ? [session!] : []
                addSessions(NSSet(array: tempSessionArray))
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
        
        /// Email
        email = attributesJSON[StudentJSON.email].string
        
        /// Gender
        gender = attributesJSON[StudentJSON.gender].string
        
        /// Age
        age = attributesJSON[StudentJSON.age].number
        
        /// Status
        status = attributesJSON[StudentJSON.status].string
        
        /// Phone
        phone = attributesJSON[StudentJSON.phone].string
        
        /// Cancellation persentage
        cancellationPercentageCharged = attributesJSON[StudentJSON.cancellationPercentageCharged].number
        
        /// Cancellation window in hrs
        cancellationWindowInHours = attributesJSON[StudentJSON.cancellationWindowInHours].number
        
        /// Default hourly rate
        defaultHourlyRateInCents = attributesJSON[StudentJSON.defaultHourlyRateInCents].number
        
        /// Session lenght in mins
        defaultSessionLengthInMinutes = attributesJSON[StudentJSON.defaultSessionLengthInMinutes].number
        
        /// Upcoming session date
        nextUpcomingSessionDate = attributesJSON[StudentJSON.nextUpcomingSessionDate].dateTime
    }
}
