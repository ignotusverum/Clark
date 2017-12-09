//
//  AutoCompleteModel.swift
//  Clark
//
//  Created by Jay Chmilewski on 3/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON
import Foundation

/// Search protocol
public protocol AutocompleteCategory {
    static var autocompleteKey: String { get set }
    static func valuesContaining(searchString: String) -> [AutocompleteCategory]
    static func valuesContainingIn(searchString: String) -> [AutocompleteCategory]
    
    var body: String { get } // Text shown when displaying cell
}

// MARK: - Auto complete model
//         These objects are used throughout the app while the DATA objects above are strictly used for storing the data in core data and fetching the very first apex value when a user is typing.
public enum AutoCompleteType {
    case text
    case values([String])
    case entity(AutocompleteCategory.Type)
}

public struct AutoCompleteModel {
    var type: AutoCompleteType
    var body: String  // The text that needs to be matched when typing
    var validEnd: Bool
    var intent: String?
    var childSwitches: [AutoCompleteModel]?
    
    init?(attributes: JSON) {
        guard let attiribute = attributes["attributes"].json, let body = attiribute["body"].string, let type = attiribute["autocomplete_switch_type"].string else {
            return nil
        }
        self.body = body
        
        let validEnd = attiribute["valid_end_of_command"].bool
        self.validEnd = validEnd != nil ? validEnd!:false
        self.intent = attiribute["autocomplete_intent"].string
        
        // Determine type and create any variables to send back in enum
        if type == "text" {
            // Normal text type, will be triggered when a user types these words into the search bar
            self.type = AutoCompleteType.text
        }
        else if type == "entity_placeholder" {
            // Here we need to do autocomplete on a certain stored entity like students or sessions
            let entityString = attiribute["autocomplete_entity_type"].string
            var entity:AutocompleteCategory.Type?
            if entityString == "Student" {
                entity = Student.self
            } else if entityString == "students" {
                entity = Student.self
            } else if entityString == "sessions" {
                entity = Session.self
            }
            if let entity = entity {
                self.type = AutoCompleteType.entity(entity)
            } else {
                print("UNKNOWN ENTITY TYPE: fix here")
                return nil
            }
        }
        else if type == "given_values_placeholder" {
            // Here we display only the given values returned in the "values" array
            if let values = attiribute["values"].arrayObject as? [String] {
                self.type = AutoCompleteType.values(values)
            } else {
                print("GIVEN VALUES ERROR: unrecognized format, fix here")
                return nil
            }
        }
        else {
            print("UNKNOWN AUTOCOMPLETE TYPE: fix here")
            return nil
        }
        
        // If still valid, set up all children
        if let childArray = attiribute["child_switches"].arrayObject as? [[String:Any]], childArray.count > 0 {
            var childSwitches:[AutoCompleteModel] = []
            for childDictionary in childArray {
                if let child = AutoCompleteModel(attributes: JSON(["attributes": childDictionary])) {
                    childSwitches.append(child)
                }
            }
            self.childSwitches = childSwitches
        }
    }
}

