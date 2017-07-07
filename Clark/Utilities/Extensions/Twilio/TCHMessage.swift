//
//  TCHMessage.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import NMessenger
import TwilioChatClient

extension Message {
    
    /// Check if author is current tutor
    var isReceiver: Bool {
        let config = Config.shared
        let currentUser = config.currentTutor
        
        // Safety check
        guard let currentUserID = currentUser?.id else {
            return true
        }
        
        // ID Check
        return currentUserID != author
    }
    
    class func createTimestamp(_ message: TCHMessage, previousMessage: TCHMessage?)-> MessageSentIndicator {
        
        // Check for timestamp & add new cell
        // Format date + attributed text
        let messageTimestamp = MessageSentIndicator()
        
        if let previousMessage = previousMessage {
            
            let difference = message.timestampAsDate.minutesFrom(previousMessage.timestampAsDate)
            
            // Difference should be > 15 min
            if difference > 15 {
                
                messageTimestamp.messageSentAttributedText = Date.convTimestamp(message.timestampAsDate)
            }
        }
        else {
            
            messageTimestamp.messageSentAttributedText = Date.convTimestamp(message.timestampAsDate)
        }
        
        return messageTimestamp
    }
}
