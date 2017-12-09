//
//  ConversationManager.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import CoreStore
import PromiseKit
import SwiftyJSON
import TwilioChatClient
import EZSwiftExtensions
import UserNotifications
import NotificationCenter

protocol ConversationManagerDelegate {
    
    /// Called when channel synchronized
    func channelSynchronized(_ channel: TCHChannel)
    
    /// Called when message added
    func messageAdded(for channel: TCHChannel, message: Message)
}

class ConversationManager: NSObject {
    
    // Shared conversation manager
    static var shared: ConversationManager?
    
    /// Current client setup
    var client: TwilioChatClient?
    
    /// Currently active channel
    var channel: TCHChannel?
    
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
            
            /// Reset
            self.shared?.client?.shutdown()
            self.shared?.client = nil
            self.shared?.channel = nil
            
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
        
        return Promise { fulfill, reject in
            
            print(accessToken)
            TwilioChatClient.chatClient(withToken: accessToken, properties: nil, delegate: self, completion: { (result, client) in
                
                guard let client = client else {
                    
                    reject(GeneralError)
                    return
                }
                
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
            client.channelsList()?.channel(withSidOrUniqueName: channelID, completion: { (result, channel) in
                
                /// Check result
                guard let channel = channel else {
                    reject(result.error ?? GeneralError)
                    return
                }
                
                /// Set channel
                self.channel = channel
                channel.join(completion: { result in
                    
                    guard result.isSuccessful() else {
                        reject(result.error ?? GeneralError)
                        return
                    }
                    
                    /// Synchronize channel
                    fulfill(channel)
                })
            })
        }
    }
    
    /// Fetch messages for channel
    ///
    /// - Parameters:
    ///   - channelID: Channel ID
    ///   - beginningIndex: Start index
    ///   - desiredNumberOfMessagesToLoad: offset
    /// - Returns: array of messages
    func fetchMessages(_ channel: TCHChannel?, beginningIndex: Int, desiredNumberOfMessagesToLoad: Int)-> Promise<[Message]> {
        
        /// Safety check
        guard let channel = channel else {
            return Promise(value: [])
        }
        
        var numberOfMessageToBeLoaded = desiredNumberOfMessagesToLoad //Number of messages that are to be loaded.
        
        return channel.getMessageCount().then { count-> Promise<[TCHMessage]> in

            var inverseBeginningIndex = Int(count) - beginningIndex //Since we load backwards, we must inverse the beginning index based on the count.
            
            if inverseBeginningIndex < 0 { //If the inverse beginning index becomes a negative number then we must lower the amount of messages to be loaded because the remaining amount is less than the desiredAmountOfMessagesToLoad.
                numberOfMessageToBeLoaded = inverseBeginningIndex + numberOfMessageToBeLoaded //Computes the remaining number of messages to load.
                inverseBeginningIndex = 0 //We know we are at the end so this can just be 0.
            }
            
            guard numberOfMessageToBeLoaded > 0, beginningIndex > 0 else {
                //These cannot be a negative.
                return Promise(value: [])
            }
            
            // Setting messages to consumed
            channel.messages!.setAllMessagesConsumed()
            return channel.messages!.getAfter(inverseBeginningIndex, withCount: desiredNumberOfMessagesToLoad)
            }.then { messages-> Promise<[Message]> in
                
                /// Updated import source
                let importSource = messages.map { (message: $0, channelID: channel.sid ?? "") }
                
                return DatabaseManager.insertASync(Into<Message>(), source: importSource)
        }
    }
    
    /// Generate form input message for current tutor
    ///
    /// - Parameters:
    ///   - body: Body message
    ///   - attributesJSON: response attributes
    class func generateFormInput(attributesJSON: JSON, message: Message) {
        
        /// Safety check
        guard let formID = attributesJSON["form_id"].string else {
            return
        }
        
        /// Conversation manager
        let convMan = ConversationManager.shared
        
        /// Check if form already exists
        let localMessage = DatabaseManager.defaultStack.fetchAll(From<Message>(), Where("\(MessageAttributes.formID.rawValue) == %@", formID))?.first
        if localMessage != nil {
            return
        }
        
        /// Safety check
        /// Create message with body
        guard let channel = convMan?.channel, let attributes = attributesJSON.dictionaryObject else {
            print("FAILED TO CREATE MESSAGE")
            return
        }
        
        let options = TCHMessageOptions()
        options.withBody("Form")
        
        /// Create attributes for message
        let tempID = UUID().uuidString
        var newAttributes: [String: Any] = ["tempId": tempID]
        newAttributes["type"] = "form_input"
        newAttributes["author"] = Config.shared.currentTutor?.id ?? "0"
        newAttributes["form_id"] = message.formInputToCreate?.id ?? "0"
        
        /// Combine
        newAttributes.combine(attributes)
        
        /// Message updates
        message.attributes = newAttributes
        message.responseAttributes = [:]
        
        /// Update attributes
        options.updateAttributes(newAttributes).then { result-> Promise<TCHResult> in
            return channel.send(options: options)
            }.catch { error in
                print(error)
        }
    }
}

// IP Messaging delegate
extension ConversationManager: TwilioChatClientDelegate {
    
    @objc(chatClient:channel:synchronizationStatusUpdated:) func chatClient(_ client: TwilioChatClient, channel: TCHChannel, synchronizationStatusUpdated status: TCHChannelSynchronizationStatus) {
        
        self.channel = channel
        
        // Pass only fully synchronized channel
        delegate?.channelSynchronized(channel)
    }
    
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
        
        /// Import source
        let messageUpdated: TCHMessage = message
        let importSource = (message: messageUpdated, channelID: "\(String(describing: channel.sid))")
         
        /// Save new message
        DatabaseManager.insertSync(Into<Message>(), source: importSource).then { response-> Promise<Message?> in
            return DatabaseManager.fetchExisting(response)
            }.then { response-> Void in
                
                /// Safety check
                guard let response = response else {
                    return
                }
                
                /// Post input messages, if not already created
                if response.formInputToCreate != nil, response.responseAttributesJSON["form_id"].string != nil {
                    
                    /// Post input messages
                    ConversationManager.generateFormInput(attributesJSON: response.responseAttributesJSON, message: response)
                }
                
                /// Send delegate
                self.delegate?.messageAdded(for: channel, message: response)
            }.catch { error in
                print(error)
        }
    }
    
    class func registerForPushNotifications(_ application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (result, error) in
                
                if error == nil {
                    
                    application.registerForRemoteNotifications()
                }
            })
        } else {
            
            let notificationSettings = UIUserNotificationSettings( types: [.badge, .sound, .alert], categories: nil)
            
            application.registerUserNotificationSettings(notificationSettings)
        }
    }

    public func updatePushToken(deviceToken: Data?) {
        
        guard let deviceToken = deviceToken else {
            return
        }
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        
        
        client?.register(withNotificationToken: deviceToken, completion: { result in
            print("result \(String(describing: result))")
        })
    }
    
    public func recievedNotification(notification: [AnyHashable : Any]) {
        client?.handleNotification(notification, completion: { result in
            
        })
    }
    
    // MARK: - Push registration
    class func deviceTokenString(_ deviceToken: Data)-> String {
        
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        return tokenString
    }
}
