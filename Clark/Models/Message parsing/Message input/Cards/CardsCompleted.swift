//
//  CardsCompleted.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/14/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON

struct CardsCompletedJSON {
    
    static let id = "card_entity_id"
    static let cardTypeString = "card_entity_type"
    
    static let subHeader = "card_subheader"
    static let header = "card_header"
}

enum CardCompletedType: String {
    case student = "student"
    case session = "session"
    case learningPlan = "learning_plan"
    case sessionReport = "session_report"
    case unknown = "unknown"
}

struct CardsCompleted {
    
    var id: String?
    
    var cardTypeString: String?
    
    var subHeader: String?
    var header: String?
    
    var type: CardCompletedType?
    
    init?(source: JSON) {
        
        /// Safety type check
        guard let id = source[CardsCompletedJSON.id].string, let type = CardCompletedType(rawValue: source[CardsCompletedJSON.cardTypeString].string ?? "") else {
            return nil
        }
        
        /// ID
        self.id = id
        
        /// Type
        self.type = type
        
        /// Type
        self.cardTypeString = source[CardsCompletedJSON.cardTypeString].string
        
        /// Sub header
        self.subHeader = source[CardsCompletedJSON.subHeader].string
        
        /// Header
        self.header = source[CardsCompletedJSON.header].string
    }
}
