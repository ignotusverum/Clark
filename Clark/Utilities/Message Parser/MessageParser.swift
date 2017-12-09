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

protocol MessageParserDelegate {
    
    /// Called when form input done pressed
    ///
    /// - Parameters:
    ///   - formInput: form input object
    ///   - message: message object
    func formInputDonePressed(_ formInput: FormInputContentNode, message: Message)
    
    /// Editing started
    func formInputEditingStarted(_ node: FormInputContentNode)
    
    /// Editing ended
    func formInputEditingEnded(_ node: FormInputContentNode)
    
    /// Images selected
    func imagesSelected(_ images: [URL])
    
    /// Card tapped
    func cardTapped(type: CardCompletedType, id: String)
    
    /// Card tapped
    func cardActionTapped(type: CardDestinationType, id: String?)
}

class MessageParser {
    
    /// Shared
    static let shared = MessageParser()
    
    /// Delegate
    var delegate: MessageParserDelegate?
    
    /// Create content node for specific type
    ///
    /// - Parameters:
    ///   - message: message object
    ///   - controller: chat controller
    /// - Returns: content node for cell
    func createContentNode(for message: Message, controller: UIViewController)-> ContentNode? {
        
        switch message.type {
        case .text:
            
            /// Check for empty message
            guard message.body.length > 0 else {
                return nil
            }
            
            // Generate text node
            let textContentNode = TextContentNode(textMessageString: message.body!, currentViewController: controller, bubbleConfiguration: ClarkBubblesConfiguration())
            textContentNode.backgroundColor = UIColor.clear
            
            /// Fonts
            textContentNode.configure(message: message)
            
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
            htmlContentNode.backgroundColor = UIColor.clear
            
            /// Fonts
            htmlContentNode.configure(message: message)
            
            return htmlContentNode
        case .image:
            /// Generate image node
            let imageNode = ImageNode(with: message.image)
            
            imageNode.view.addTapGesture(action: { gesture in
                guard let url = message.image else {
                    return
                }
                
                self.delegate?.imagesSelected([url])
            })
            
            return imageNode
        case .carousel:
            /// Generate carousel node
            let carouselContentNode = CarouselContentNode(carouselItems: message.carousel, currentViewController: controller)
            
            carouselContentNode.delegate = self
            carouselContentNode.backgroundColor = UIColor.clear
            
            return carouselContentNode
        case .formInput:
            
            /// Safety check for legacy creation
            guard message.formInputs != nil else {
                return nil
            }
            
            /// Generate form input node
            let formInputNode = FormInputContentNode(message: message, currentViewController: controller)
            
            formInputNode.backgroundColor = UIColor.clear
            
            /// Form input actions
            formInputNode.delegate = self
            
            return formInputNode
        case .card:
            
            /// Safety check
            guard let model = message.cardCompleted else {
                return nil
            }
            
            let cardNode = CardCompletedNode(model: model, currentViewController: controller)
            
            cardNode.backgroundColor = UIColor.clear
            cardNode.delegate = self
            
            return cardNode
        case .cardAction:
            
            /// Safety check
            guard let cardModel = CardAction(source: message.attributesJSON, title: message.body) else {
                return nil
            }
            
            let cardAction = CardActionNode(model: cardModel, currentViewController: controller, bubbleConfiguration: ClarkBubblesConfiguration())
            cardAction.backgroundColor = UIColor.clear
            cardAction.delegate = self
            
            return cardAction
        default:
            
            print("NOT SUPPORTED \(message.type)")
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
    func createGroups(oldGroup: MessageGroup?, padding: UIEdgeInsets, controller: UIViewController, responseMessages: [Message] = [], shouldShowTimestamp: Bool = true)-> ([MessageGroup]) {
        
        var result: [MessageGroup] = []
        
        /// Shared message parser
        let messageParser = MessageParser.shared
        
        for (index, message) in responseMessages.enumerated() {
            
            // Generate content node
            if let contentNode = messageParser.createContentNode(for: message, controller: controller) {
                
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
                if result.last == nil || result.last?.isIncomingMessage == !message.isReceiver || (message.isShouldCreateGroup || previous.isShouldCreateGroup) {
                    
                    let newMessageGroup = MessageParser.createMessageGroup(message: message, padding: padding, controller: controller)
                    
                    // Check if node is not empty
                    if let text = messageTimestamp.messageSentAttributedText, text.length > 0, shouldShowTimestamp == true {
                        
                        let newTimestampGroup = MessageParser.createMessageGroup(padding: padding, controller: controller)
                        newTimestampGroup.addMessageToGroup(messageTimestamp, completion: nil)
                        
                        result.append(newTimestampGroup)
                    }
                    
                    /// Temp solution for carousel - adding title message
                    if message.type == .carousel || message.type == .formInput && message.body.length > 0 && message.body.lowercased() != "form" && message.body.lowercased() != "preview image" {
                        
                        /// Title
                        let titleContentNode = TextContentNode(textMessageString: message.body, bubbleConfiguration: ClarkBubblesConfiguration())
                        
                        /// Configure
                        titleContentNode.configure(message: message)
                        
                        /// Message
                        let titleMessage = MessageNode(content: titleContentNode)
                        if let lastGroup = result.last {
                            
                            /// Last group is current group type
                            if lastGroup.isIncomingMessage && message.type != .cardAction {
                                /// Title
                                lastGroup.addMessageToGroup(titleMessage, completion: nil)
                            }
                            else {
                                
                                /// New group
                                let newGroup = MessageParser.createMessageGroup(padding: padding, controller: controller)
                                
                                newGroup.avatarNode = Avatars.createAvatar()
                                newGroup.addMessageToGroup(titleMessage, completion: nil)
                                result.append(newGroup)
                            }
                        }
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
        case .text, .html, .cardAction:
            
            newMessageGroup.cellPadding = padding
        case .formInput, .card:
            
            newMessageGroup.cellPadding = UIEdgeInsets(top: 15, left: -30, bottom: 15, right: -30)
        case .image:
            
            newMessageGroup.cellPadding = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5)
        case .cardAction:
            
            newMessageGroup.cellPadding = UIEdgeInsets(top: 0, left: 46, bottom: 0, right: 0)
        default:
            
            newMessageGroup.cellPadding = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: -30)
        }
        
        /// Show avatar only for clark
        /// Show avatar only for messageType text
        if message.isReceiver && (message.type == .text || message.type == .html || message.type == .cardAction) {
            newMessageGroup.avatarNode = Avatars.createAvatar()
        }
        else if message.type == .text {
            newMessageGroup.avatarNode = Avatars.createEmptyAvatar()
        }
        
        newMessageGroup.isIncomingMessage = message.isReceiver
        
        newMessageGroup.backgroundColor = UIColor.clear
        
        return newMessageGroup
    }
}

extension MessageParser: FormInputContentNodeDelegate {
    
    /// Editing started
    func formInputEditingStarted(_ node: FormInputContentNode) {
        delegate?.formInputEditingStarted(node)
    }
    
    /// Editing ended
    func formInputEditingEnded(_ node: FormInputContentNode) {
        delegate?.formInputEditingEnded(node)
    }
    
    /// Called when done button pressed on keyboard
    ///
    /// - Parameters:
    ///   - node: current node
    ///   - formInputs: form inputs
    func formInputsOnDoneButton(node: FormInputContentNode, message: Message){
        delegate?.formInputDonePressed(node, message: message)
    }
}

/// Carousel delegate
extension MessageParser: CarouselContentDelegate {
    /// Images selected
    func datasourceSelected(items: [CarouselItem]) {
        /// Passing url
        let urls = items.flatMap { $0.imageURL }
        delegate?.imagesSelected(urls)
    }
}

// MARK: - Card delegate
extension MessageParser: CardCompletedNodeDelegate {
    func cardTapped(type: CardCompletedType?, id: String?) {
        
        /// Safety check
        guard let type = type, let id = id else {
            return
        }
        
        /// Callback
        delegate?.cardTapped(type: type, id: id)
    }
}

// MARK: - Card action delegate
extension MessageParser: CardActionNodeDelegate {
    func cardTapped(type: CardDestinationType?, id: String?) {
        
        /// Safety check
        guard let type = type else {
            return
        }
        
        delegate?.cardActionTapped(type: type, id: id)
    }
}
