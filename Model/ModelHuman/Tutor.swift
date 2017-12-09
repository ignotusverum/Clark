//
//  Tutor.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

/// Struct that represent Tutor JSON keys
public struct TutorJSON {
    
    static let firstName = "first_name"
    static let lastName = "last_name"
    
    static let phone = "phone"
    
    static let email = "email"
    
    static let imageURL = "imageURL"
    
    static let bio = "bio"
    
    static let subjectsTaught = "subjects"
    
    static let twilioToken = "twilio_token"
    static let twilioExpirationDate = "twilio_expiration_date"
    static let twilioPrimaryChannelID = "twilio_primary_channel_id"
    
    static let preferredContactMethod = "preferred_contact_method"
    static let pushNotificationsEnabled = "mobile_push_notifications_on"
    static let defaultHourlyRateInCents = "default_hourly_rate_in_cents"
    static let defaultSessionLengthInMinutes = "default_session_length_in_minutes"
}

@objc(Tutor)
open class Tutor: _Tutor {
    
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
    
    /// Subjects array
    var subjectsArray: [Subject] {
        return subjects.allObjects as? [Subject] ?? []
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
    
    /// Model update logic
    override func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {
        
        try super.updateModel(with: source, transaction: transaction)
        
        /// Safety check for attributes
        guard let attributesJSON = source[ModelJSON.attributes].json else {
            return
        }
        
        /// Fist Name
        firstName = attributesJSON[TutorJSON.firstName].string
        
        /// Last name
        lastName = attributesJSON[TutorJSON.lastName].string
        
        /// Email
        email = attributesJSON[TutorJSON.email].string
        
        /// Phone
        phone = attributesJSON[TutorJSON.phone].phone
        
        /// Image URL
        imageURL = attributesJSON[TutorJSON.imageURL].string
        
        /// Bio
        bio = attributesJSON[TutorJSON.bio].string
        
        /// Subjects taught
        subjectsTaught = attributesJSON[TutorJSON.subjectsTaught].string
        
        /// Default hourly rate
        defaultHourlyRateInCents = attributesJSON[TutorJSON.defaultHourlyRateInCents].number ?? 0
        
        /// Default session lenght
        defaultSessionLengthInMinutes = attributesJSON[TutorJSON.defaultSessionLengthInMinutes].number ?? 0
        
        /// Contant method
        preferredContactMethod = attributesJSON[TutorJSON.preferredContactMethod].string
        
        /// Push
        pushNotificationsEnabled = attributesJSON[TutorJSON.pushNotificationsEnabled].number        
    }
}
