//
//  QuickAction.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

/// Types of quick action
public enum QuickActionTrigger: String {
    case timerEnd = "timer_end"
    case message = "send_message"
    case timerPause = "timer_pause"
    case externalLink = "go_to_external_web_page"
}

/// Quick action struct
struct QuickAction {
    
    /// Action
    var trigger: QuickActionTrigger
    
    /// Body
    var body: String
    
    /// Toggle
    var toggleString: String?
    
    /// Link
    var link: URL?
    
    /// Return properties
    var returnMessageBody: String?
    var returnMessageAttributes: [String: Any]?
    
    // MARK: - Initialization
    init?(attributes: JSON) {
        
        /// Safety type check
        guard let actionString = attributes["type"].string, let body = attributes["text"].string, let trigger = QuickActionTrigger(rawValue: actionString) else {
            return nil
        }
        
        /// Trigger
        self.trigger = trigger
        self.body = body
        
        /// Link
        self.link = attributes["external_url"].url
        
        /// Return params
        self.returnMessageBody = attributes["send_message_body"].string
        self.returnMessageAttributes = attributes["send_message_attributes"].dictionaryObject
        
        /// Trigegr check
        if trigger == .timerPause {
            toggleString = "Resume"
        }
        else if let toggle = attributes["toggle_text"].string {
            toggleString = toggle
        }
    }
}
