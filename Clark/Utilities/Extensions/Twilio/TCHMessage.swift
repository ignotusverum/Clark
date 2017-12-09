//
//  TCHMessage.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import NMessenger
import PromiseKit
import TwilioChatClient

extension TCHMessage {
    
    /// Promise wrapped set attributes
    ///
    /// - Parameter attributes: attributes
    /// - Returns: TCH result
    func updateAttributes(_ attributes: [String: Any])-> Promise<TCHResult> {
        
        /// Promise wrapper
        return Promise { fulfil, reject in
            
            /// Set attributes call
            self.setAttributes(attributes, completion: { result in
                
                /// Safety check
                guard result.isSuccessful() else {
                    reject(GeneralError)
                    return
                }
                
                fulfil(result)
            })
        }
    }
}

extension TCHMessageOptions {
    
    /// Promise wrapped set attributes
    ///
    /// - Parameter attributes: attributes
    /// - Returns: TCH result
    func updateAttributes(_ attributes: [String: Any])-> Promise<TCHResult> {
        
        /// Promise wrapper
        return Promise { fulfil, reject in
            
            /// Set attributes call
            self.withAttributes(attributes, completion: { result in
                
                /// Safety check
                guard result.isSuccessful() else {
                    reject(GeneralError)
                    return
                }
                
                fulfil(result)
            })
        }
    }
}

extension Message {
    
    /// Check if author is current tutor
    var isReceiver: Bool {
        
        let config = Config.shared
        let currentUser = config.currentTutor?.id
        
        // Safety check
        guard let currentUserID = currentUser else {
            
            guard let tempUserID = Config.userID else {
                return false
            }
            
            /// Temp user check - pre login
            return tempUserID != author
        }
        
        // ID Check
        return currentUserID != author
    }
    
    /// Create timestamp for messages
    ///
    /// - Parameters:
    ///   - message: first message to check
    ///   - previousMessage: previous message to check
    /// - Returns: reutrn message sent indicator
    class func createTimestamp(_ message: Message, previousMessage: Message?)-> MessageSentIndicator {
        
        // Check for timestamp & add new cell
        // Format date + attributed text
        let messageTimestamp = MessageSentIndicator()
        
        if let previousMessage = previousMessage {
            
            let difference = message.sent!.minutesFrom(previousMessage.sent!)
            
            // Difference should be > 15 min
            if difference > 15 {
                
                messageTimestamp.messageSentAttributedText = Date.convTimestamp(message.sent!)
            }
        }
        else {
            
            messageTimestamp.messageSentAttributedText = Date.convTimestamp(message.sent!)
        }
        
        return messageTimestamp
    }
}

