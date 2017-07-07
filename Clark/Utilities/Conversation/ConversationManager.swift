//
//  ConversationManager.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import CoreStore
import NMessenger
import PromiseKit
import TwilioChatClient

protocol ConversationManagerDelegate {
    
    func messageAdded(for channel: TCHChannel, message: Message)
}

class ConversationManager: NSObject {
    
    // Shared conversation manager
    static var shared: ConversationManager?
    
    var client: TwilioChatClient?
    
    // Delegate
    var delegate: ConversationManagerDelegate?
    
    // Sender identity
    var identity = ""
    
    // Credentials
    var accessToken = ""
    
    /// Start inital conversation
    ///
    /// - Returns: Twilio chat client
    class func conversationStart()-> Promise<TwilioChatClient?> {
        return LaunchChannelManager.createNewChannelOrUpdate().then { token, identity-> Promise<TwilioChatClient?> in
            
            /// Initialize conversation manager
            let convMan = ConversationManager(accessToken: token, identity: identity)
            self.shared = convMan
            
            return convMan.promiseClient()
        }
    }
    
    /// Initialize client with current token/identituy
    ///
    /// - Returns: Twilio chat client
    private func promiseClient()-> Promise<TwilioChatClient?> {
        
        client = nil
        
        return Promise { fulfill, reject in
            
            print(accessToken)
            TwilioChatClient.chatClient(withToken: accessToken, properties: nil, delegate: self, completion: { (result, client) in
                
                self.client = client
                fulfill(client)
            })
            
            TwilioChatClient.setLogLevel(.critical)
        }
    }
    
    init(accessToken: String, identity: String) {
        
        self.identity = identity
        self.accessToken = accessToken
        
        super.init()
    }
    
    func synchronizeChannel(_ channelID: String?)-> Promise<TCHChannel?> {
        
        /// Safety checks
        guard let client = self.client, let channelID = channelID else {
            return Promise(value: nil)
        }
        
        /// Main promise
        return Promise { fulfill, reject in
            
            /// Synchronize channel
            client.channelsList().channel(withSidOrUniqueName: channelID, completion: { (result, channel) in
                
                /// Check result
                guard let channel = channel else {
                    reject(GeneralError)
                    return
                }
                
                /// Synchronize channel
                fulfill(channel)
            })
        }
    }
    
    
    /// Fetch messages for NMMessager
    ///
    /// - Parameter channelID: Channel ID
    /// - Returns: Array of cells
    class func fetchMessageCells(for channelID: String, start: Int, offset: Int, controller: UIViewController, configuration: BubbleConfigurationProtocol)-> Promise<([GeneralMessengerCell], [Message])> {
        
        /// Synchronize channel
        let convMan = ConversationManager.shared
        return convMan!.synchronizeChannel(channelID).then { response-> Promise<[Message]> in
            
            /// Fetch messager
            return convMan!.fetchMessages(response, beginningIndex: start, desiredNumberOfMessagesToLoad: offset)
            }.then { responseMessages-> ([GeneralMessengerCell], [Message]) in
             
                /// Result array
                var result: [GeneralMessengerCell] = []
                
                for (index, message) in responseMessages.enumerated() {
                    if message.body.length > 0 {
                        
                        // Generate text ode
                        let textContentNode = TextContentNode(textMessageString: message.body!, currentViewController: controller, bubbleConfiguration: configuration)
                        
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
                        
                        // Check if node is not empty
                        if let text = messageTimestamp.messageSentAttributedText, text.length > 0 {
                            result.append(messageTimestamp)
                        }
                        
                        // Cell padding update
                        let messageNode = MessageNode(content: textContentNode)
                        
                        messageNode.currentViewController = controller
                        
                        // Author check
                        messageNode.isIncomingMessage = message.isReceiver
                        
                        result.append(messageNode)
                    }
                }
                
                return (result, responseMessages)
        }
    }
    
    /// Fetch messages for channel
    ///
    /// - Parameters:
    ///   - channelID: Channel ID
    ///   - beginningIndex: Start index
    ///   - desiredNumberOfMessagesToLoad: offset
    /// - Returns: array of messages
    private func fetchMessages(_ channel: TCHChannel?, beginningIndex: Int, desiredNumberOfMessagesToLoad: Int)-> Promise<[Message]> {
        
        /// Safety check
        guard let channel = channel else {
            return Promise(value: [])
        }
        
        var numberOfMessageToBeLoaded = desiredNumberOfMessagesToLoad //Number of messages that are to be loaded.
        
        return channel.getMessageCount().then { count-> Promise<[TCHMessage]> in
            
            if channel.messages == nil {
                return Promise(value: [])
            }
            
            // Setting messages to consumed
            channel.messages.setAllMessagesConsumed()
            
            var inverseBeginningIndex = Int(count) - beginningIndex //Since we load backwards, we must inverse the beginning index based on the count.
            
            if inverseBeginningIndex < 0 { //If the inverse beginning index becomes a negative number then we must lower the amount of messages to be loaded because the remaining amount is less than the desiredAmountOfMessagesToLoad.
                numberOfMessageToBeLoaded = inverseBeginningIndex + numberOfMessageToBeLoaded //Computes the remaining number of messages to load.
                inverseBeginningIndex = 0 //We know we are at the end so this can just be 0.
            }
            
            guard numberOfMessageToBeLoaded > 0, beginningIndex > 0 else {
                //These cannot be a negative.
                return Promise(value: [])
            }
            
            return channel.messages.getAfter(inverseBeginningIndex, withCount: desiredNumberOfMessagesToLoad)
            }.then { messages-> Promise<[Message]> in
                
                /// Updated import source
                let importSource = messages.map { (message: $0, channelID: "\(channel.sid)") }
                return DatabaseManager.insertASync(Into<Message>(), source: importSource)
            }.then { response-> Promise<[Message]> in
                return DatabaseManager.fetchExisting(response)
        }
    }
}

// IP Messaging delegate
extension ConversationManager: TwilioChatClientDelegate {
    
    @objc(chatClient:channel:synchronizationStatusUpdated:) func chatClient(_ client: TwilioChatClient!, channel: TCHChannel!, synchronizationStatusUpdated status: TCHChannelSynchronizationStatus) {
        // Pass only fully synchronized channel
    }
    
    func chatClient(_ client: TwilioChatClient!, channel: TCHChannel!, messageAdded message: TCHMessage!) {
        
        /// Import source
        let messageUpdated: TCHMessage = message
        let importSource = (message: messageUpdated, channelID: "\(channel.sid)")
        
        /// Save new message
        DatabaseManager.insertSync(Into<Message>(), source: importSource).then { response-> Promise<Message?> in
            return DatabaseManager.fetchExisting(response)
            }.then { response-> Void in
                
                /// Safety check
                guard let response = response else {
                    return
                }
                
                /// Send delegate
                self.delegate?.messageAdded(for: channel, message: response)
            }.catch { error in
                print(error)
        }
    }
}

