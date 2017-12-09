//
//  Validation.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/12/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Stripe
import PhoneNumberKit

enum CreateError: Error {

    case firstName
    case lastName

    case phone
    case email
    case country

    case subject

    case rate
    case duration

    case date
    case time

    case frequency

    func copy()-> String {

        switch self {
        case .firstName:
            return "Whoops, please enter a first name"
        case .lastName:
            return "Whoops, please enter a last name"
        case .phone:
            return "Whoops, please enter a valid phone number"
        case .country:
            return "Whoops, please enter a valid country code"
        case .email:
            return "Whoops, please enter a valid email"
        case .subject:
            return "Whoops, please select a subject"
        case .rate:
            return "Whoops, please enter a valid hourly rate"
        case .duration:
            return "Whoops, please enter a valid duration"
        case .time:
            return "Whoops, please enter a valid time"
        case .date:
            return "Whoops, please enter a valid date"
        case .frequency:
            return "Whoops, please enter a valid session frequency"
        }
    }
}

class Validation {

    class func isValidEmail(_ email: String?)-> Bool {

        guard let email = email else {

            return false
        }

        let emailString = email.NoWhiteSpace

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)

        let result = emailTest.evaluate(with: emailString)

        return result
    }


    class func isValidPhone(_ phone: String?, countryCode: String?)-> Bool {

        guard let phone = phone, let countryCode = countryCode else {

            return false
        }

        do {

            let phoneNumberKit = PhoneNumberKit()
            let _ = try phoneNumberKit.parse(phone, withRegion: countryCode)

            return true
        }
        catch {
            return false
        }
    }

    class func isValidPostalCode(_ postalCode: String?)-> Bool {

        guard let postalCode = postalCode, postalCode.length > 2 else {

            return false
        }

        return true
    }

    class func isValidPassword(_ password: String?)-> Bool {

        guard let password = password, password.length >= 8 else {

            return false
        }

        return true
    }

    class func isValidName(_ name: String?)-> Bool {

        if let name = name, name.length > 0 {
            return true
        }

        return false
    }

    class func containsSpecialCharacters(_ string: String)-> Bool {

        let characterset = NSCharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
        if string.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }

        return false
    }

    /// Validate first/last name input
    class func validateName(first: String?, last: String?)-> CreateError? {

        /// First name check
        guard Validation.isValidName(first) else {
            return .firstName
        }

        /// Last name check
        guard Validation.isValidName(last) else {
            return .lastName
        }

        return nil
    }

    /// Validate learning plan rate
    class func validateLearningPlanRate(_ rate: String?, duration: String?, frequency: String?)-> CreateError? {

        if let rateError = validateContactRate(rate) {
            return rateError
        }

        if let duration = duration, duration.length == 0 {
            return .duration
        }

        guard let _ = frequency else {
            return .frequency
        }

        return nil
    }

    /// Validate rate duration day time
    class func validateSessionRate(_ rate: String?, duration: String?, day: Date?, time: Date?)-> CreateError? {

        if let rateError = validateContactRate(rate) {
            return rateError
        }

        if let duration = duration, duration.length == 0 {
            return .duration
        }

        guard let _ = day else {
            return .date
        }

        guard let _ = time else {
            return .time
        }

        return nil
    }

    /// Validate contact inputs
    class func validateContactType(type: StudentContactType, entry: String?, country: String?)-> CreateError? {

        /// Input check
        guard let entry = entry else {
            return type == .mobile ? .phone : .email
        }

        switch type {
        case .email:
            return Validation.isValidEmail(entry) ? nil : .email
        case .mobile:

            if country == nil {
                return .phone
            }

            return Validation.isValidPhone(entry, countryCode: country) ? nil : .phone
        }
    }

    /// Validate subjects selection
    class func validateContactSubject(_ subject: Subject?)-> CreateError? {

        guard let _ = subject else {
            return .subject
        }

        return nil
    }

    /// Validate subjects rate
    class func validateContactRate(_ rate: String?)-> CreateError? {

        guard let rate = rate, rate.length > 0 else {
            return .rate
        }

        return nil
    }
}
