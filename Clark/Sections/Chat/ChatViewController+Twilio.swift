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
import SwiftyJSON
import AsyncDisplayKit
import EZSwiftExtensions

extension ChatViewController {
    
    /// Attributes for Clark debugging
    var globalAttributes: [String:Any]  {
        
        let serverString = HostName == "Dev" ? "qa" : "production"
        
        let build = ez.appBuild!
        let version = ez.appVersion!
        
        let newAttributes: [String:Any] = ["data_environment":serverString,
                                          "build":build,
                                          "version":version,
                                          "os":UIDevice.current.systemVersion,
                                          "screen_size":"\(UIScreen.main.bounds.size)",
            "time_zone":TimeZone.current.identifier,
            "region":Locale.current.regionCode ?? "unknown",
            "language":Locale.current.languageCode ?? "unknown"]
        
        return ["device_data": newAttributes]
    }
    
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
                        
                        /// Fonts
                        textContentNode.configure()
                        
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
                            else {
                                newMessageGroup.avatarNode = self.createEmptyAvatar()
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
    /// Send message
    func sendMessage(_ body: String) {
        
        /// Check if length > 0
        guard body.length > 0 else {
            return
        }
        
        /// Send to channel
        let msg = channel?.messages.createMessage(withBody: body)
        
        /// Text attributes
        var textAttributes: [String: Any] = ["blocking": false, "type": "text", "tempId": UUID().uuidString]
        textAttributes.combine(globalAttributes)
        
        /// Set attributes + send message
        msg?.setAttributes(textAttributes, completion: { result in
            
            self.channel?.messages.send(msg) { result in }
        })
    }
    
    /// Post text
    func postText(_ text: String, isIncoming: Bool) {
     
        // Text node params
        let textContentNode = TextContentNode(textMessageString: text, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
        
        /// Configur fonts
        textContentNode.configure()
        
        /// Create mesasge node
        let messageNode = MessageNode(content: textContentNode)
        messageNode.cellPadding = messagePadding
        messageNode.currentViewController = self
        
        // Checking is author
        messageNode.isIncomingMessage = isIncoming
        
        /// Update insets
        automaticallyAdjustsScrollViewInsets = false
        
        if lastGroup == nil || lastGroup?.isIncomingMessage == !isIncoming {
            
            /// New Group
            lastGroup = createMessageGroup()
            
            //add avatar if incoming message
            if isIncoming {
                lastGroup?.avatarNode = createAvatar()
            }
            else {
                lastGroup?.avatarNode = createEmptyAvatar()
            }
            
            lastGroup?.isIncomingMessage = isIncoming
            messengerView.addMessageToMessageGroup(messageNode, messageGroup: lastGroup!, scrollsToLastMessage: true)
            messengerView.addMessage(lastGroup!, scrollsToMessage: true, withAnimation: isIncoming ? .left : .right)
        }
        else {
            
            messengerView.addMessageToMessageGroup(messageNode, messageGroup: lastGroup!, scrollsToLastMessage: true)
        }
    }
    
    /**
     Creates clark avatar with an AsyncDisplaykit *ASImageNode*.
     - returns: ASImageNode
     */
    func createAvatar()-> ASImageNode {
        
        let avatar = ASImageNode()
        avatar.image = #imageLiteral(resourceName: "empty")
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
    
    /// Creates empty avatar
    ///
    /// - Returns: avatar node
    func createEmptyAvatar()-> ASImageNode {
        
        let avatar = ASImageNode()
        avatar.backgroundColor = UIColor.clear
        avatar.style.preferredSize = CGSize(width: 1, height: 1)
        
        return avatar
    }
    
    /// Creates new message group with default params
    ///
    /// - Returns: message group
    func createMessageGroup()-> MessageGroup {
        let newMessageGroup = MessageGroup()
        newMessageGroup.currentViewController = self
        newMessageGroup.cellPadding = messagePadding
        return newMessageGroup
    }
    
    /// Shows typing indicator for 45 secs
    ///
    /// - Returns: Typing indicator reference
    func showTypingIndicator()-> GeneralMessengerCell {
        
        let clarkAvatar = createAvatar()
        let indicator = showTypingIndicator(clarkAvatar)
        
        indicator.cellPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        /// Hide after delay
        ez.runThisAfterDelay(seconds: 45) {
            DispatchQueue.main.async {
                self.removeTypingIndicator(indicator)
            }
        }
        
        return indicator
    }
}
