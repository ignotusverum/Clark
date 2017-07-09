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
                let resultGroups = MessageParser.createGroups(oldGroup: self.lastGroup, padding: self.messagePadding, controller: self, responseMessages: responseMessages)
                
                return (resultGroups, responseMessages)
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
    func postMessage(_ message: Message, isIncoming: Bool) {
     
        // Text node params
        if let contentNode = MessageParser.createContentNode(for: message, controller: self) {
        
            /// Create mesasge node
            let messageNode = ClarkMessageNode(content: contentNode, message: message)
            messageNode.cellPadding = messagePadding
            messageNode.currentViewController = self
            
            // Checking is author
            messageNode.isIncomingMessage = isIncoming
            
            /// Update insets
            automaticallyAdjustsScrollViewInsets = false
            
            if lastGroup == nil || lastGroup?.isIncomingMessage == !isIncoming || message.type != .text {
                
                /// New Group
                lastGroup = MessageParser.createMessageGroup(message: message, padding: messagePadding, controller: self)
                
                messengerView.addMessageToMessageGroup(messageNode, messageGroup: lastGroup!, scrollsToLastMessage: true)
                messengerView.addMessage(lastGroup!, scrollsToMessage: true, withAnimation: isIncoming ? .left : .right)
            }
            else {
                
                messengerView.addMessageToMessageGroup(messageNode, messageGroup: lastGroup!, scrollsToLastMessage: true)
            }
        }
    }
    
    /// Shows typing indicator for 45 secs
    ///
    /// - Returns: Typing indicator reference
    func showTypingIndicator()-> GeneralMessengerCell {
        
        let clarkAvatar = Avatars.createAvatar()
        let indicator = showTypingIndicator(clarkAvatar)
        
        indicator.cellPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        /// Hide after delay
        ez.runThisAfterDelay(seconds: 45) {
            DispatchQueue.main.async {
                if let _ = self.typingIndicator {
                    self.removeTypingIndicator(self.typingIndicator!)
                    self.typingIndicator = nil
                }
            }
        }

        return indicator
    }
}
