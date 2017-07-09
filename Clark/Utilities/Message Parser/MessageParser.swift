//
//  MessageParser.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation
import NMessenger

class MessageParser {
    
    /// Create content node for specific type
    ///
    /// - Parameters:
    ///   - message: message object
    ///   - controller: chat controller
    /// - Returns: content node for cell
    class func createConentNode(for message: Message, controller: UIViewController)-> ContentNode? {
     
        switch message.type {
        case .text:
            
            /// Check for empty message
            guard message.body.length > 0 else {
                return nil
            }
            
            // Generate text node
            let textContentNode = TextContentNode(textMessageString: message.body!, currentViewController: controller, bubbleConfiguration: ClarkBubblesConfiguration())
            
            /// Fonts
            textContentNode.configure()
            
            return textContentNode
        case .carousel:
            /// Generate carousel node
            let carouselContentNode = CarouselContentNode(carouselItems: message.carousel, currentViewController: controller)
            
            return carouselContentNode
        default:
            
            return nil
        }
    }
    
    /// Create / Update message group with new message
    ///
    /// - Parameters:
    ///   - message: Message model
    ///   - oldGroup: Old group reference
    ///   - padding: Group padding
    ///   - controller: Chat controller
    /// - Returns: Group
    class func createGroups(oldGroup: MessageGroup?, padding: UIEdgeInsets, controller: UIViewController, responseMessages: [Message] = [])-> ([MessageGroup]) {
        
        var result: [MessageGroup] = []
        
        for (index, message) in responseMessages.enumerated() {
        
            // Generate content node
            if let contentNode = MessageParser.createConentNode(for: message, controller: controller) {
                
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
                let messageNode = MessageNode(content: contentNode)
                messageNode.currentViewController = controller
                
                // Author check
                messageNode.isIncomingMessage = message.isReceiver
                
                /// New group
                if result.last == nil || result.last?.isIncomingMessage == !message.isReceiver {
                    
                    let newMessageGroup = self.createMessageGroup(padding: padding, controller: controller)
                    
                    // Check if node is not empty
                    if let text = messageTimestamp.messageSentAttributedText, text.length > 0 {
                        
                        let newTimestampGroup = self.createMessageGroup(padding: padding, controller: controller)
                        newTimestampGroup.addMessageToGroup(messageTimestamp, completion: nil)
                        
                        result.append(newTimestampGroup)
                    }
                    
                    if message.isReceiver {
                        newMessageGroup.avatarNode = Avatars.createAvatar()
                    }
                    else {
                        newMessageGroup.avatarNode = Avatars.createEmptyAvatar()
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
        
        return result
    }
    
    /// Creates new message group with default params
    ///
    /// - Returns: message group
    class func createMessageGroup(padding: UIEdgeInsets, controller: UIViewController)-> MessageGroup {
        let newMessageGroup = MessageGroup()
        newMessageGroup.currentViewController = controller
        newMessageGroup.cellPadding = padding
        return newMessageGroup
    }
}
