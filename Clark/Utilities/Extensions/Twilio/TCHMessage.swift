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

        let currentUser = Config.userID
        
        // Safety check
        guard let currentUserID = currentUser else {
            return false
        }
        
        // ID Check
        return currentUserID != author
    }
    
    class func createTimestamp(_ message: Message, previousMessage: Message?)-> MessageSentIndicator {
        
        // Check for timestamp & add new cell
        // Format date + attributed text
        let messageTimestamp = MessageSentIndicator()
        
        if let previousMessage = previousMessage {
            
            let difference = message.sent.minutesFrom(previousMessage.sent)
            
            // Difference should be > 15 min
            if difference > 15 {
                
                messageTimestamp.messageSentAttributedText = Date.convTimestamp(message.sent)
            }
        }
        else {
            
            messageTimestamp.messageSentAttributedText = Date.convTimestamp(message.sent)
        }
        
        return messageTimestamp
    }
}
