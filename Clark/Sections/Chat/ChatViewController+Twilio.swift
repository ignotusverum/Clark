//
//  ChatViewController+Twilio.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation
import NMessenger
import PromiseKit
import AsyncDisplayKit

extension ChatViewController {
    
    /// Fetch messages for NMMessager
    ///
    /// - Parameter channelID: Channel ID
    /// - Returns: Array of cells
    func fetchMessageCells(for channelID: String, start: Int, offset: Int)-> Promise<([MessageGroup], [Message])> {
        
        /// Synchronize channel
        let convMan = ConversationManager.shared
        return convMan!.synchronizeChannel(channelID).then { response-> Promise<[Message]> in
            
            /// Fetch messager
            return convMan!.fetchMessages(response, beginningIndex: start, desiredNumberOfMessagesToLoad: offset)
            }.then { responseMessages-> ([MessageGroup], [Message]) in
                
                /// Result message groups
                var result: [MessageGroup] = []
                
                for (index, message) in responseMessages.enumerated() {
                    if message.body.length > 0 {
                        
                        // Generate text ode
                        let textContentNode = TextContentNode(textMessageString: message.body!, currentViewController: self, bubbleConfiguration: ClarkBubblesConfiguration())
                        
                        textContentNode.incomingTextFont = UIFont.AvenirNextRegular(size: 15)
                        textContentNode.outgoingTextFont = UIFont.AvenirNextRegular(size: 15)
                        
                        textContentNode.incomingTextColor = UIColor.messageIncomingColor
                        textContentNode.outgoingTextColor = UIColor.white
                        
                        // Create empty timestamp
                        var messageTimestamp = MessageSentIndicator()
                        
                        // If first message - always show timestamp
                        if index == 0 {
                            
                            messageTimestamp = Message.createTimestamp(message, previousMessage: nil)
                        }
                        else if responseMessages.count > index {
                            
                            // Safety check
                            // Create timestamp with time difference
                            let previous = responseMessages[index-1]
                            messageTimestamp = Message.createTimestamp(message, previousMessage: previous)
                        }
                        
                        // Cell padding update
                        let messageNode = MessageNode(content: textContentNode)
                        
                        messageNode.currentViewController = self
                        
                        // Author check
                        messageNode.isIncomingMessage = message.isReceiver
                        
                        /// New group
                        if result.last == nil || result.last?.isIncomingMessage == !message.isReceiver {
                  
                            let newMessageGroup = self.createMessageGroup()
                            
                            // Check if node is not empty
                            if let text = messageTimestamp.messageSentAttributedText, text.length > 0 {
                            
                                let newTimestampGroup = self.createMessageGroup()
                                newTimestampGroup.addMessageToGroup(messageTimestamp, completion: nil)
                                
                                result.append(newTimestampGroup)
                            }
                            
                            if message.isReceiver {
                                newMessageGroup.avatarNode = self.createAvatar()
                            }
                            
                            newMessageGroup.isIncomingMessage = message.isReceiver
                            newMessageGroup.addMessageToGroup(messageNode, completion: nil)
                            
                            result.append(newMessageGroup)
                        }
                        else {
                            
                            result.last?.addMessageToGroup(messageNode, completion: nil)
                        }
                    }
                }
                
                return (result, responseMessages)
        }
    }
    
    // MARK: - Utilities
    /**
     Creates mock avatar with an AsyncDisplaykit *ASImageNode*.
     - returns: ASImageNode
     */
    func createAvatar()-> ASImageNode {
        
        let avatar = ASImageNode()
        avatar.backgroundColor = UIColor.trinidad
        avatar.style.preferredSize = CGSize(width: 36, height: 36)
        avatar.layer.cornerRadius = 18
        
        let config = Config.shared
        let isOpen = config.currentDay?.isCurrentlyOpen ?? false
        
        let isOpenCircle = ASImageNode()
        isOpenCircle.backgroundColor = isOpen ? UIColor.green : UIColor.red
        isOpenCircle.style.preferredSize = CGSize(width: 14, height: 14)
        isOpenCircle.layer.cornerRadius = 7
        
        isOpenCircle.borderWidth = 2
        isOpenCircle.borderColor = UIColor.white.cgColor
        
        isOpenCircle.frame = CGRect(x: 36 - 14, y: 36 - 14, w: 15, h: 15)
        
        avatar.addSubnode(isOpenCircle)
        
        return avatar
    }
    
    func createMessageGroup()-> MessageGroup {
        let newMessageGroup = MessageGroup()
        newMessageGroup.currentViewController = self
        newMessageGroup.cellPadding = self.messagePadding
        return newMessageGroup
    }
}
