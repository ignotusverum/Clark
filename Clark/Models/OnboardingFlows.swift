//
//  OnboardingFlows.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/16/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import SwiftyJSON

enum OnboardingStatus: String {
    case onboardingStatus = "onboarding_statuses"
}

public struct OnboardingFlows {
    
    var id: String
    var typeString: String?
    var type: OnboardingStatus?
    var headline: String?
    var description: String?
    var completed: Bool
    
    init?(json: JSON) {
        
        guard let id = json["id"].string, let attributes = json["attributes"].json else {
            return nil
        }
        
        self.id = id
        self.typeString = json["type"].string
        
        if let typeString = self.typeString {
            self.type = OnboardingStatus(rawValue: typeString)
        }
        
        self.headline = attributes["headline"].string
        self.description = attributes["description"].string
        self.completed = attributes["completed"].bool ?? false
    }
}
