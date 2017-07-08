//
//  MessageAttributes.swift
//  Clark
//
//  Created by Jay Chmilewski on 12/21/16.
//  Copyright © 2016 Clark. All rights reserved.
//

import Stripe
import CoreData
import Foundation

// MARK: - AutoComplete

public protocol AutocompleteCategory {
    static var autocompleteKey:String {get set}
    static func valuesContainedIn(searchString:String, moc:NSManagedObjectContext) -> [AutocompleteCategory]
    static func valuesContaining(searchString:String, moc:NSManagedObjectContext) -> [AutocompleteCategory]
    
    var body:String {get} // Text shown when displaying cell
    var imageURL:URL? {get} // URL to any image media shown with the category cell
}


// MARK: Form Enums

enum FormType:String {
    case signup = "signup"
    case login = "login"
    case simple = "simple"
    case custom = "custom"
}

enum FormState:String {
    case submitted = "submitted"
    case unsubmitted = "unsubmitted"
    case hasErrors = "has_errors"
    case invalidated = "invalidated"
}

enum FormInputType:String {
    case text = "text"
    case secret = "secret"
    case switchButton = "radio_switch"
    case checkmarkButton = "radio_button"
    case slider = "slider"
}

enum ValidationType:String {
    case patternMatch = "pattern_match"
    case requiredLength = "required_length"
    case maxLength = "max_length"
    case minLength = "min_length"
}

// MARK: Form Structs
public struct CustomForm {
    var id:String
    
    var type:FormType = .custom
    
    var textInputs: [FormInput] = []
    var switches: [SwitchButton] = []
    var radioButtons: [RadioButtons] = []
    var sliders: [Slider] = []
    
    var title: String?
    var subtitle: String?
    
    var state: FormState = .unsubmitted
    
    // Unlike reponse type above, hand in the messages full attributes array for this method
    init?(attributes:[String:Any]) {
        
        guard let id = attributes["form_id"] as? String,
            let inputs = attributes["form_inputs"] as? [[String:Any]] else { return nil}
        if let type = attributes["form_type"] as? String, let formType = FormType(rawValue: type) {
            self.type = formType
        }
        if let state = attributes["form_state"] as? String, let formState = FormState(rawValue: state) {
            self.state = formState
        }
        
        self.title = attributes["form_title"] as? String
        self.subtitle = attributes["form_subtitle"] as? String
        
        textInputs = []
        switches = []
        sliders = []
        radioButtons = []
        
        for input in inputs {
            
            if input["type"] as? String == "text" {
                
                if let formInput = FormInput(attributes: input) {
                    textInputs.append(formInput)
                }
            }
            else if input["type"] as? String == "radio_button" {
                
                if let formInput = RadioButtons(attributes: input) {
                    radioButtons.append(formInput)
                }
            } else if input["type"] as? String == "radio_switch" {
                if let formInput = SwitchButton(attributes: input) {
                    switches.append(formInput)
                }
            } else if input["type"] as? String == "slider" {
                if let formInput = Slider(attributes: input) {
                    sliders.append(formInput)
                }
             }
        }
        
        self.id = id
        
        if textInputs.count > 0 && (sliders.count + switches.count + radioButtons.count == 0) && type != .login && type != .signup {
            self.type = .simple
        }
    }
}


public struct Form {
    var id:String
    var type:FormType = .simple
    var inputs:[FormInput]
    var state:FormState = .unsubmitted
    
    // Unlike reponse type above, hand in the messages full attributes array for this method
    init?(attributes:[String:Any]) {
        guard let id = attributes["form_id"] as? String,
            let inputs = attributes["form_inputs"] as? [[String:Any]] else { return nil}
        if let type = attributes["form_type"] as? String, let formType = FormType(rawValue: type) {
            self.type = formType
        }
        if let state = attributes["form_state"] as? String, let formState = FormState(rawValue: state) {
            self.state = formState
        }
        let formInputs = inputs.map({ FormInput(attributes:$0) })
        let validInputs = formInputs.flatMap({ $0}) // Removes all nil values
        self.id = id
        self.inputs = validInputs
    }
}

class Slider: InputData {
    
    override var type: FormInputType {
        return .slider
    }
    
    var displayName:String?
    var rangeStart: Int?
    var rangeEnd: Int?
    var rangeIncrement: Int = 1
    
    override var attributes:[String:Any] {
        var dictionary: [String:Any] = [:]
        dictionary["type"] = self.type.rawValue
        dictionary["name"] = self.name
        dictionary["display_name"] = self.displayName
        dictionary["value"] = self.value
        
        return dictionary
    }
    
    init?(attributes:[String:Any]) {
        
        super.init()
        
        guard let name = attributes["name"] as? String else { return nil }
        
        self.rangeEnd = attributes["range_end"] as? Int
        self.rangeStart = attributes["range_start"] as? Int
        self.rangeIncrement = attributes["range_increment"] as? Int ?? 1
        self.name = name
        self.displayName = attributes["display_name"] as? String
        self.value = attributes["value"] as? String
    }
}

class SwitchButton: InputData {

    override var type: FormInputType {
        return .switchButton
    }
    
    var displayName:String?
    
    override var attributes:[String:Any] {
        var dictionary: [String:Any] = [:]
        dictionary["type"] = self.type.rawValue
        dictionary["name"] = self.name
        dictionary["display_name"] = self.displayName
        dictionary["value"] = self.value
        
        return dictionary
    }
    
    init?(attributes:[String:Any]) {
        
        super.init()
        
        guard let name = attributes["name"] as? String else { return nil }
        
        self.name = name
        self.displayName = attributes["display_name"] as? String
        self.value = attributes["value"] as? String
    }
}

public struct RadioButton {
    var value: String?
    var displayName:String?
}

class RadioButtons: InputData {
    
    override var type: FormInputType {
        return .checkmarkButton
    }
    
    var layout: String?
    var displayName:String?
    var buttons: [RadioButton] = []
    
    override var attributes:[String:Any] {
        var dictionary: [String:Any] = [:]
        dictionary["type"] = self.type.rawValue
        dictionary["name"] = self.name
        dictionary["display_name"] = self.displayName
        dictionary["value"] = self.value
        
        dictionary["radio_button_layout"] = self.layout
        dictionary["radio_button_options"] = buttons.map { ["value": $0.value ?? "", "display_name": $0.displayName ?? ""] }
        
        return dictionary
    }
    
    init?(attributes:[String:Any]) {
        
        super.init()
        
        guard let name = attributes["name"] as? String else { return nil }
        
        self.name = name
        self.displayName = attributes["display_name"] as? String
        self.value = attributes["value"] as? String
        
        if let options = attributes["radio_button_options"] as? [[String: String]] {
            buttons = []
            for option in options {
             
               buttons.append(RadioButton(value: option["value"], displayName: option["display_name"]))
            }
        }
    }
}

protocol InputDataProtocol {
    
    var name: String? {get set}
    var value: String? {get set}
}

class InputData: InputDataProtocol {
    
    var type: FormInputType {
        return .text
    }
    
    var name: String?
    var value: String?
    var attributes: [String: Any] {
        return [:]
    }
}

class FormInput: InputData {
    
    override var type: FormInputType {
        return .text
    }
    
    var placeholder:String?
    var displayName:String?
    var validationRules:[ValidationRule]?
    var keyboardType:UIKeyboardType = .default
    var captitalizationType:UITextAutocapitalizationType = .sentences
    var autocorrectType:UITextAutocorrectionType = .default
    var error:InputError?
    
    override var attributes:[String:Any] {
        var dictionary: [String:Any] = [:]
        dictionary["type"] = self.type.rawValue
        dictionary["name"] = self.name
        dictionary["placeholder"] = self.placeholder
        dictionary["display_name"] = self.displayName
        dictionary["value"] = self.value
        if let validationRules = self.validationRules {
            var rules: [[String:Any]] = []
            for rule in validationRules {
                rules.append(rule.attributes)
            }
            dictionary["validation_rules"] = rules
        }
        dictionary["input_error"] = self.error?.attributes
        
        switch self.keyboardType {
        case .numberPad:
            dictionary["keyboard_type"] = "number_pad"
        case .phonePad:
            dictionary["keyboard_type"] = "phone_pad"
        case .emailAddress:
            dictionary["keyboard_type"] = "email"
        default:
            dictionary["keyboard_type"] = "default"
        }
        
        switch self.captitalizationType {
        case .allCharacters:
            dictionary["keyboard_capitalization_rule"] = "all_letters"
        case .words:
            dictionary["keyboard_capitalization_rule"] = "all_words"
        case .none:
            dictionary["keyboard_capitalization_rule"] = "none"
        case .sentences:
            dictionary["keyboard_capitalization_rule"] = "first_word_only"
        }
        
        switch self.autocorrectType {
        case .yes:
            dictionary["autocorrect"] = "yes"
        case .no:
            dictionary["autocorrect"] = "no"
        case .default:
            dictionary["autocorrect"] = ""
        }
        return dictionary
    }
    
    init?(attributes:[String:Any]) {
        
        super.init()
        
        guard let name = attributes["name"] as? String else { return nil }
        
        self.name = name
        self.placeholder = attributes["placeholder"] as? String
        self.displayName = attributes["display_name"] as? String
        self.value = attributes["value"] as? String
        let validationRules = attributes["validation_rules"] as? [[String:Any]]
        var rules:[ValidationRule] = []
        if let validationRules = validationRules {
            let validationRules = validationRules.map{ ValidationRule(attributes:$0) }
            rules = validationRules.flatMap({ $0 })
        }
        self.validationRules = rules
        if let errorDictionary = attributes["input_error"] as? [String:Any] {
            self.error = InputError(attributes: errorDictionary)
        }

        // Set keyboard type
        if let keyboardTypeString = attributes["keyboard_type"] as? String {
            if keyboardTypeString == "number_pad" {
                keyboardType = .numberPad
            } else if keyboardTypeString == "phone_pad" {
                keyboardType = .phonePad
            } else if keyboardTypeString == "email" {
                keyboardType = .emailAddress
            }
        }
        
        // Set capitalization type
        if let capitalizationTypeString = attributes["keyboard_capitalization_rule"] as? String {
            if capitalizationTypeString == "all_letters" {
                captitalizationType = .allCharacters
            } else if capitalizationTypeString == "all_words" {
                captitalizationType = .words
            } else if capitalizationTypeString == "none" {
                captitalizationType = .none
            }
        }
        
        // Set autocorrect type
        if let autocorrectTypeString = attributes["autocorrect"] as? String {
            if autocorrectTypeString == "yes" {
                autocorrectType = .yes
            } else if autocorrectTypeString == "no" {
                autocorrectType = .no
            }
        }
    }
}

struct ValidationRule {
    private var type:ValidationType
    private var value:String
    
    init?(attributes:[String:Any]) {
        guard let typeString = attributes["type"] as? String, let type = ValidationType(rawValue: typeString), let value = attributes["value"] as? String else { return nil }
        self.type = type
        self.value = value
    }
    
    var attributes:[String:Any] {
        var dictionary: [String:Any] = [:]
        dictionary["type"] = self.type.rawValue
        dictionary["value"] = self.value
        return dictionary
    }
    
    func validate(response:String?) -> Bool {
        switch type {
        case .maxLength:
            guard let charCount = response?.characters.count, let valueInt = Int(value) else {return false}
            return charCount <= valueInt
        case .minLength:
            guard let charCount = response?.characters.count, let valueInt = Int(value) else {return false}
            return charCount >= valueInt
        case .patternMatch:
            let predicate = NSPredicate(format:"SELF MATCHES %@", self.value)
            return predicate.evaluate(with: response)
        case .requiredLength:
            guard let charCount = response?.characters.count, let valueInt = Int(value) else {return false}
            return charCount == valueInt
        }
    }
}

struct InputError {
    var inputName:String?
    var givenValue:String?
    var messages:[String] = []
    
    var attributes:[String:Any] {
        var dictionary: [String:Any] = [:]
        dictionary["friendly_input_name"] = self.inputName
        dictionary["given_value"] = self.givenValue
        dictionary["messages"] = self.messages
        return dictionary
    }
    
    init(attributes:[String:Any]) {
        self.inputName = attributes["friendly_input_name"] as? String
        self.givenValue = attributes["given_value"] as? String
        if let messages = attributes["messages"] as? [String] {
            self.messages = messages
        }
    }
}

// MARK: - Timer
enum TimerState:String {
    case new = "new"
    case inProgress = "in_progress"
    case paused = "paused"
    case completed = "completed"
}

public struct TimerObject {
    let state:TimerState
    let durationInSeconds:Int64
    let pausedAtSecond:Int64
    let timerPausedAt: Date?
    let timerStartedAt: Date?

    init(attributes:[String:Any], privateAttributes:[String:Any]? = nil) {
        if let durationInSeconds = privateAttributes?["timer_duration_in_seconds"] as? Int {
            self.durationInSeconds = Int64(durationInSeconds)
        } else if let durationInSeconds = attributes["timer_duration_in_seconds"] as? Int {
            self.durationInSeconds = Int64(durationInSeconds)
        } else {
            self.durationInSeconds = 0  // Default value in case of bad key entry on backend
        }
        
        if let state = attributes["timer_state"] as? String, let timerState = TimerState(rawValue: state), timerState == .completed {
            // Extra override in case private attributes arent updating correctly.
            self.state = .completed
        } else if let state = privateAttributes?["timer_state"] as? String, let timerState = TimerState(rawValue: state) {
            self.state = timerState
        } else if let state = attributes["timer_state"] as? String, let timerState = TimerState(rawValue: state){
            self.state = timerState
        }  else {
            self.state = .completed  // Default value in case of bad key entry on backend
        }
        
        if let pausedAtSecond = privateAttributes?["timer_paused_at_second"] as? Int {
            self.pausedAtSecond = Int64(pausedAtSecond)
        } else if let pausedAtSecond = attributes["timer_paused_at_second"] as? Int{
            self.pausedAtSecond = Int64(pausedAtSecond)
        } else {
            self.pausedAtSecond = 0
        }
        
        if let timerPausedAt = privateAttributes?["timerPausedAt"] as? Date {
            self.timerPausedAt = timerPausedAt
        } else {
            self.timerPausedAt = nil
        }
        
        if let timerStartedAt = privateAttributes?["timerStartedAt"] as? Date {
            self.timerStartedAt = timerStartedAt
        } else {
            self.timerStartedAt = nil
        }
    }
}

// MARK: - Stripe info
public struct StripeInfo {
    var holderName:String
    var holderType:STPBankAccountHolderType = .individual
    var token:String?
    var stripeError:String?
    
    var attributes:[String:Any] {
        var dictionary:[String:Any] = [:]
        dictionary["account_holder_name"] = self.holderName
        if self.holderType == .company {
            dictionary["account_holder_type"] = "business"
        } else {
            dictionary["account_holder_type"] = "individual"
        }
        dictionary["stripe_bank_token"] = self.token
        dictionary["stripe_api_error"] = self.stripeError
        return dictionary
    }
    
    // Unlike reponse type above, hand in the messages full attributes array for this method
    init?(attributes:[String:Any]) {
        guard let holderName = attributes["bank_account_holder_name"] as? String,
            let holderType = attributes["bank_account_holder_type"] as? String else { return nil}
        self.holderName = holderName
        if holderType.lowercased() == "individual" {
            self.holderType = STPBankAccountHolderType.individual
        } else if holderType.lowercased() == "business" {
            self.holderType = STPBankAccountHolderType.company
        }
        self.token = attributes["stripe_bank_token"] as? String
        self.stripeError = attributes["stripe_api_error"] as? String
    }
}

// MARK: - Carousel

enum CarouselType:String {
    case image = "image"
    case progressReport = "progress_report"
    case paymentRecord = "payment_record"
}

public struct CarouselItem {
    let type:CarouselType
    var imageURL:URL?
    
    init?(attributes:[String:Any]) {
        guard let typeString = attributes["type"] as? String,
            let type = CarouselType(rawValue: typeString) else { return nil}
        
        self.type = type
        if let urlString = attributes["image_url"] as? String {
            self.imageURL = URL(string: urlString)
        }
        
    }
}
