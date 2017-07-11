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
import AsyncDisplayKit

class MessageParser {
    
    /// Create content node for specific type
    ///
    /// - Parameters:
    ///   - message: message object
    ///   - controller: chat controller
    /// - Returns: content node for cell
    class func createContentNode(for message: Message, controller: UIViewController)-> ContentNode? {
     
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
        case .html:
            
            /// Check for empty message
            guard message.body.length > 0 else {
                return nil
            }
            
            /// Generate text node with html
            let htmlContentNode = ClarkHTMLNode(textMessageString: message.body!, currentViewController: controller, bubbleConfiguration: ClarkBubblesConfiguration())
            htmlContentNode.message = message
            htmlContentNode.textMessageString = message.htmlBody
            
            /// Fonts
            htmlContentNode.configure()
            
            return htmlContentNode
        case .carousel:
            /// Generate carousel node
            let carouselContentNode = CarouselContentNode(carouselItems: message.carousel, currentViewController: controller)
            
            return carouselContentNode
        case .formInput:
            
            /// Generate form input node
            let formInputNode = FormInputContentNode(formInputs: message.formInputs!, currentViewController: controller)
            
            return formInputNode
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
            if let contentNode = MessageParser.createContentNode(for: message, controller: controller) {
                
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
                let messageNode = ClarkMessageNode(content: contentNode, message: message)
                messageNode.currentViewController = controller
                
                // Author check
                messageNode.isIncomingMessage = message.isReceiver
                
                let previous = index == 0 ? message : responseMessages[index-1]
                
                /// New group
                /// Create new group if there's no group
                /// If new message incoming type is not equal to last message incoming type
                /// If Message type is carousel
                if result.last == nil || result.last?.isIncomingMessage == !message.isReceiver || (message.type == .carousel || message.type == .formInput) || (previous.type == .carousel || previous.type == .formInput) {
                    
                    let newMessageGroup = createMessageGroup(message: message, padding: padding, controller: controller)
                    
                    // Check if node is not empty
                    if let text = messageTimestamp.messageSentAttributedText, text.length > 0 {
                        
                        let newTimestampGroup = self.createMessageGroup(padding: padding, controller: controller)
                        newTimestampGroup.addMessageToGroup(messageTimestamp, completion: nil)
                        
                        result.append(newTimestampGroup)
                    }
                    
                    /// Temp solution for carousel - adding title message
                    if message.type == .carousel {
                        
                        /// Title
                        let titleContentNode = TextContentNode(textMessageString: message.body, bubbleConfiguration: ClarkBubblesConfiguration())
                        
                        /// Configure
                        titleContentNode.configure()
                        
                        /// Message
                        let titleMessage = MessageNode(content: titleContentNode)
                        
                        /// Title
                        result.last?.addMessageToGroup(titleMessage, completion: nil)
                    }
                    
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
    
    /// Create message group for message
    ///
    /// - Parameters:
    ///   - message: message object
    ///   - padding: padding
    ///   - controller: controller
    /// - Returns: message group
    class func createMessageGroup(message: Message, padding: UIEdgeInsets, controller: UIViewController)-> MessageGroup {
        
        let newMessageGroup = MessageGroup()
        newMessageGroup.currentViewController = controller
        
        /// Type setup
        switch message.type {
        case .text:
            
            newMessageGroup.cellPadding = padding
        default:
            
            newMessageGroup.cellPadding = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: -30)
        }
        
        /// Show avatar only for clark
        /// Show avatar only for messageType text
        if message.isReceiver, (message.type == .text || message.type == .html) {
            newMessageGroup.avatarNode = Avatars.createAvatar()
        }
        else if message.type == .text {
            newMessageGroup.avatarNode = Avatars.createEmptyAvatar()
        }
        
        newMessageGroup.isIncomingMessage = message.isReceiver
        
        return newMessageGroup
    }
}
