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

    static let firstName = "firstName"
    static let lastName = "lastName"
    
    static let phone = "phone"
    
    static let email = "email"
    
    static let imageURL = "imageURL"
    
    static let bio = "bio"
    
    static let subjectsTaught = "subjectsTaught"
    
    static let twilioToken = "twilioToken"
    static let twilioExpirationDate = "twilioExpirationDate"
    static let twilioPrimaryChannelID = "twilioPrimaryChannelID"
    
    static let preferredContactMethod = "preferredContactMethod"
    static let pushNotificationsEnabled = "pushNotificationsEnabled"
	static let defaultHourlyRateInCents = "defaultHourlyRateInCents"
	static let defaultSessionLengthInMinutes = "defaultSessionLengthInMinutes"
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
        phone = attributesJSON[TutorJSON.phone].string
        
        /// Image URL
        imageURL = attributesJSON[TutorJSON.imageURL].string
        
        /// Bio
        bio = attributesJSON[TutorJSON.bio].string
        
        /// Subjects taught
        subjectsTaught = attributesJSON[TutorJSON.subjectsTaught].string
        
        /// Default hourly rate
        defaultHourlyRateInCents = attributesJSON[TutorJSON.defaultHourlyRateInCents].number
        
        /// Default session lenght
        defaultSessionLengthInMinutes = attributesJSON[TutorJSON.defaultSessionLengthInMinutes].number
        
        /// Contant method
        preferredContactMethod = attributesJSON[TutorJSON.preferredContactMethod].string
        
        /// Push
        pushNotificationsEnabled = attributesJSON[TutorJSON.pushNotificationsEnabled].number
        
        /// Twillio
        twilioToken = attributesJSON[TutorJSON.twilioToken].string
        twilioExpirationDate = attributesJSON[TutorJSON.twilioExpirationDate].dateTime
        twilioPrimaryChannelID = attributesJSON[TutorJSON.twilioPrimaryChannelID].string
    }
}
