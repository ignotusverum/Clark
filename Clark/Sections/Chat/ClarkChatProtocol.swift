//
//  ClarkChatProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/17/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Analytics
import CoreStore
import NMessenger
import PromiseKit
import SwiftyJSON
import SVProgressHUD
import AsyncDisplayKit
import TwilioChatClient
import EZSwiftExtensions

/// Attributes for Clark debugging
let globalAttributes: [String: Any] = ["data_environment": MacroEnviroment == "Dev" ? "qa" : "production",
                                       "build": ez.appBuild!,
                                       "version": ez.appVersion!,
                                       "os": UIDevice.current.systemVersion,
                                       "screen_size": "\(UIScreen.main.bounds.size)",
                                       "time_zone": TimeZone.current.identifier,
                                       "region": Locale.current.regionCode ?? "unknown",
                                       "language": Locale.current.languageCode ?? "unknown",
                                       "platform" : "iOS",
                                       "anonymous_user_id": SEGAnalytics.shared().getAnonymousId()]

protocol ClarkChatProtocol: class {
    
    /// Page size
    var pageSize: Int { get }
    
    /// Current page
    var currentPage: Int { get set }
    
    /// Chat Action contaner
    var chatActionContainerView: ChatActionContainerView { get set }
    
    /// Current channel
    var channel: TCHChannel? { get set }
    
    /// Datasource
    var messages: [Message] { get set }
    
    /// Last group
    var lastGroup: MessageGroup? { get set }
    
    /// Chat input control
    var chatInputBar: ChatInputBar { get set }
    
    /// Typing indicator
    var typingIndicator: GeneralMessengerCell? { get set }
    
    /// Keyboard height
    var keyboardHeight: CGFloat { get set }
    
    /// Message insets
    var messagePadding: UIEdgeInsets { get set }
    
    // MARK: - Functions
    /// Fetch messages with loader promise
    func fetchMessages(showLoading: Bool, loadMore: Bool)
    
    /// Nav bar setup
    func initialSetup()
    
    /// UI converstion setup
    func conversationUISetup()
}

// MARK: - Fetching logic
extension ClarkChatProtocol where Self: NMessengerViewController {
    
    /// Fetch messages for NMMessager
    ///
    /// - Parameter channelID: Channel ID
    /// - Returns: Array of cells
    func fetchMessageCells(for channelID: String, start: Int, offset: Int)-> Promise<([MessageGroup], [Message])> {
        
        /// Message parser setup
        let messageParser = MessageParser.shared
        
        /// Synchronize channel
        let convMan = ConversationManager.shared
        return convMan!.synchronizeChannel(channelID).then { response-> Promise<[Message]> in
            
            /// Fetch messager
            return convMan!.fetchMessages(response, beginningIndex: start, desiredNumberOfMessagesToLoad: offset)
            }.then { responseMessages-> ([MessageGroup], [Message]) in
                
                /// Post input messages, if not already created
                let needToCreateMessages = responseMessages.filter { $0.formInputToCreate != nil && $0.responseAttributesJSON["form_id"].string != nil }

                for message in needToCreateMessages {
                    
                    /// Post input messages
                    ConversationManager.generateFormInput(attributesJSON: message.responseAttributesJSON, message: message)
                }
                
                /// Result message groups
                let resultGroups = messageParser.createGroups(oldGroup: self.lastGroup, padding: self.messagePadding, controller: self, responseMessages: responseMessages)
                
                return (resultGroups, responseMessages)
        }
    }
    
    // MARK: - Fetch messages
    func fetchMessages(showLoading: Bool, loadMore: Bool = false) {
        
        /// Safety check
        guard let channelID = Config.channelID else {
            return
        }
        
        /// Show loading logic
        if showLoading {
            SVProgressHUD.dismiss()
            SVProgressHUD.show()
        }
        
        fetchMessageCells(for: channelID, start: pageSize * currentPage, offset: pageSize).then { groups, messages-> Void in
            
            /// Do not update UI if there's no new messages
            if messages.count == 0 {
                return
            }
            
            self.messages.append(contentsOf: messages)
            SVProgressHUD.dismiss()
            
            /// Do not update UI if it's same number of messages
            if self.messages.count == messages.count {
                return
            }
            
            /// Update controller with messages
            DispatchQueue.main.async {
                
                if self.messengerView.allMessages().isEmpty { //If there are no messages we have to use the add messages function, otherwise to add new chats to the top, we use endBatchFetch
                    
                    self.messengerView.addMessages(groups, scrollsToMessage: false)
                    
                    ez.runThisAfterDelay(seconds: 0.1, after: {
                        
                        self.messengerView.scrollToLastMessage(animated: false)
                    })
                    
                    self.lastGroup = groups.last
                }
                else {
                    /// Finish updates
                    self.messengerView.endBatchFetchWithMessages(groups)
                }
            }
            
            if !loadMore {
                /// Update action view
                if let lastMessageCheck = self.messages.last {
                    
                    let _ = DatabaseManager.fetchExisting(lastMessageCheck).then { response-> Void in
                     
                        guard let response = response else {
                            return
                        }
                        
                        if self.chatActionContainerView.message != response {
                            
                            /// Update Action controller with message
                            self.chatActionContainerView.message = response
                        }
                        
                        /// Update imput with message
                        self.chatInputBar.isEnabled = !(response.blocking?.boolValue ?? false)
                    }
                }
            }
            
            if messages.count == 0 {
                self.fetchMessages(showLoading: false, loadMore: false)
            }
            
            }.catch { error in
                SVProgressHUD.dismiss()
        }
    }
    
    /// Called when message added to channel
    internal func messageAdded(for channel: TCHChannel, message: Message) {
        
        /// Hide if message from clark
        if message.isReceiver {
            if let indicator = typingIndicator {
                
                /// Remove
                removeTypingIndicator(indicator)
                self.typingIndicator = nil
            }
        }
        
        /// Update imput with message
        chatInputBar.isEnabled = !(message.blocking?.boolValue ?? false)
        
        /// Update datasource
        messages.append(message)
        
        let lastMessage = messages.last
        
        // Set all messages as consumed
        channel.messages?.setAllMessagesConsumed()
        
        var messageTimestamp = MessageSentIndicator()
        
        /// Create timestamp
        messageTimestamp = Message.createTimestamp(message, previousMessage: lastMessage)
        if let text = messageTimestamp.messageSentText, text.length > 0 {
            
            let newTimestampGroup = MessageParser.createMessageGroup(padding: messagePadding, controller: self)
            newTimestampGroup.addMessageToGroup(messageTimestamp, completion: nil)
            
            messengerView.addMessage(newTimestampGroup, scrollsToMessage: true)
        }
        
        postMessage(message, isIncoming: message.isReceiver)
        
        /// Update Action controller with message
        chatActionContainerView.message = message
        
        /// Update imput with message
        chatInputBar.isEnabled = !(message.blocking?.boolValue ?? false)
        if !chatInputBar.isEnabled {
            view.endEditing(true)
        }
        
        /// Update layout
        updateChatActionViewPosition()
        
        ez.runThisAfterDelay(seconds: 0.1, after: {
            self.messengerView.scrollToLastMessage(animated: false)
        })
    }
}

// MARK: - Keyboard logic
extension ClarkChatProtocol where Self: NMessengerViewController {

    // MARK: - Keyboard notifications
    func keyboardWillShow(frame: CGRect) {
        
        keyboardHeight = frame.height
        
        /// Update chat action position
        updateChatActionViewPosition(frame.height)
    }
    
    func keyboardWillHide(frame: CGRect) {
    
        /// Update chat action position
        updateChatActionViewPosition()
    }
}

// MARK: - Twillio + message parsing logic
extension ClarkChatProtocol where Self: NMessengerViewController {

    // MARK: - Utilities
    /// Send message
    func sendMessage(_ body: String) {
        
        /// Check if length > 0
        guard body.length > 0 else {
            return
        }
        
        /// Send to channel
        let options = TCHMessageOptions()
        options.withBody(body)
        
        /// Text attributes
        var textAttributes: [String: Any] = ["blocking": false, "type": "text", "tempId": UUID().uuidString]
        
        textAttributes.combine(["device_data": globalAttributes])
        options.withAttributes(textAttributes) { result in
            self.channel?.messages?.sendMessage(with: options, completion: nil)
        }
    }
    
    /// Post text
    func postMessage(_ message: Message, isIncoming: Bool) {
        
        /// Message parser setup
        let messageParser = MessageParser.shared
        
        // Text node params
        if let contentNode = messageParser.createContentNode(for: message, controller: self) {
            
            /// Create mesasge node
            let messageNode = ClarkMessageNode(content: contentNode, message: message)
            messageNode.cellPadding = messagePadding
            messageNode.currentViewController = self
            
            // Checking is author
            messageNode.isIncomingMessage = isIncoming
            
            /// Update insets
            automaticallyAdjustsScrollViewInsets = false
            
            /// Type check
            var shouldCreatGroup = false
            let lastGroupMessage = lastGroup?.messages.last
            if let lastMessage = lastGroupMessage as? ClarkMessageNode  {
                
                shouldCreatGroup = lastMessage.message.isShouldCreateGroup || message.isShouldCreateGroup
            }
            
            if lastGroup == nil || lastGroup?.isIncomingMessage == !isIncoming || shouldCreatGroup {
                
                /// New Group
                lastGroup = MessageParser.createMessageGroup(message: message, padding: messagePadding, controller: self)
                
                /// Temp solution for carousel - adding title message
                if message.isShouldCreateGroup && message.body.length > 0 && message.shouldShowMessageBody {
                    
                    /// Title
                    let titleContentNode = TextContentNode(textMessageString: message.body, bubbleConfiguration: ClarkBubblesConfiguration())
                    
                    /// Configure
                    titleContentNode.configure(message: message)
                    
                    /// Message
                    let titleMessage = MessageNode(content: titleContentNode)
                    
                    /// New group
                    let newGroup = MessageParser.createMessageGroup(padding: messagePadding, controller: self)
                    
                    newGroup.avatarNode = Avatars.createAvatar()
                    newGroup.addMessageToGroup(titleMessage, completion: nil)
                    
                    messengerView.addMessage(newGroup, scrollsToMessage: false, withAnimation: isIncoming ? .left : .right)
                }
                
                messengerView.addMessageToMessageGroup(messageNode, messageGroup: lastGroup!, scrollsToLastMessage: true)
                messengerView.addMessage(lastGroup!, scrollsToMessage: true, withAnimation: isIncoming ? .left : .right)
            }
            else {
                
                messengerView.addMessageToMessageGroup(messageNode, messageGroup: lastGroup!, scrollsToLastMessage: true)
            }
            
            /// Update action view
            let lastMessage = messages.last
            if let lastMessage = lastMessage {
                
                /// Update imput with message
                self.chatInputBar.isEnabled = !(lastMessage.blocking?.boolValue ?? false)
            }
        }
    }
    
    /// Shows typing indicator for 45 secs
    ///
    /// - Returns: Typing indicator reference
    func showTypingIndicator() {
        
        if let typingIndicator = self.typingIndicator {
            removeTypingIndicator(typingIndicator)
        }
        
        let clarkAvatar = Avatars.createAvatar()
        let indicator = showClarkTypingIndicator(clarkAvatar)
        
        /// Hide after delay
        
        /// 45 delay
        ez.runThisAfterDelay(seconds: 45) {

            if let typingIndicator = self.typingIndicator {
                self.removeTypingIndicator(typingIndicator)
                self.typingIndicator = nil
            }
        }

        self.typingIndicator = indicator
    }
}

// MARK: - Chat action delegate
extension ClarkChatProtocol where Self: NMessengerViewController {
    
    /// Called when action selected
    func containerView_(_ containerView: ChatActionContainerView, selectedAction: QuickAction, message: Message) {
        
        /// Open link
        if let link = selectedAction.link {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
            return
        }
        
        // Check if we should send reply message
        if let replyBody = selectedAction.returnMessageBody {
            sendMessage(replyBody)
        }
    }
    
    /// Called when reply selected
    func containerView_(_ containerView: ChatActionContainerView, selectedReply: QuickReply, message: Message) {
        
        /// Send to channel
        sendMessage(selectedReply.body)
        
        ez.runThisAfterDelay(seconds: 0.5) {
            /// Show typing indicator
            self.showTypingIndicator()
        }
    }
    
    /// Called when type changed to visible
    func containerView_(_ containerView: ChatActionContainerView, changedTo type: ChatActionContainerViewType) {
        
        /// Update position
        updateChatActionViewPosition()
    }
    
    /// Update actionContainer based on input bar position
    func updateChatActionViewPosition(_ yPos: CGFloat = 0) {
        
        /// Update chat inest
        updateInset()
        
        /// Animate layout
        UIView.animate(withDuration: 0.2) {
            
            /// Chat Action container layout
            self.chatActionContainerView.snp.updateConstraints { maker in
                maker.bottom.equalTo(-self.inputBarView.frame.height - yPos)
                maker.left.equalTo(self.view)
                maker.right.equalTo(self.view)
                maker.height.equalTo(self.chatActionContainerView.contentHeight)
            }
            
            /// Layout update
            self.view.layoutIfNeeded()
        }
    }
    
    func updateInset(topInset: CGFloat = 0) {
        
        /// Update table view inset
        messengerView.messengerNode.view.contentInset = UIEdgeInsets(top: 0 + topInset, left: 0, bottom: chatActionContainerView.contentHeight + inputBarView.frame.height, right: 0)
    }
    
    func createClarkTypingIndicator(_ avatar: ASDisplayNode?) -> GeneralMessengerCell
    {
        let typing = ClarkTypingIndicator(bubbleConfiguration: self.sharedBubbleConfiguration)
        let newMessage = MessageNode(content: typing)
        newMessage.avatarNode = avatar
        
        return newMessage
    }
    
    internal func showClarkTypingIndicator(_ avatar: ASDisplayNode?) -> GeneralMessengerCell
    {
        let newMessage = self.createClarkTypingIndicator(avatar)
        if newMessage != nil && messengerView != nil {
            messengerView.addTypingIndicator(newMessage, scrollsToLast: false, animated: true, completion: nil)
        }
        return newMessage
    }
}
