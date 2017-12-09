//
//  CardAction.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/15/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON

/// Struct that represent CardAction JSON keys
public struct CardActionJSON {
    
    static let body = "body"
    static let destination = "app_destination"
    static let sessionID = "session_id"
    static let studentID = "student_id"
}

/// Card destination types
enum CardDestinationType: String {
    case student = "add_student_form"
    case session = "add_session_form"
    case learningPlan = "add_learning_plan_form"
    case sessionReport = "add_session_report_form"
}

struct CardAction {
    
    var body: String?
    var destinationString: String?
    
    var title: String?
    
    var id: String?
    
    var destination: CardDestinationType? {
        return CardDestinationType(rawValue: destinationString ?? "")
    }
    
    init?(source: JSON?, title: String?) {
        
        guard let source = source, let attributes = source[MessageJSON.quickActions].array, let first = attributes.first, let destination_ = first[CardActionJSON.destination].string else {
            return nil
        }
        
        /// Title
        self.title = title
        
        /// Body
        body = first[CardActionJSON.body].string
        
        /// Destination
        destinationString = destination_
        
        /// id
        if destination == .sessionReport || destination == .learningPlan {
            id = destination == .sessionReport ? first[CardActionJSON.sessionID].string : first[CardActionJSON.studentID].string
        }
    }
}
