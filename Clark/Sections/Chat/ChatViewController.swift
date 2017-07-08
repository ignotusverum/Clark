//
//  ChatViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import NMessenger
import SVProgressHUD
import TwilioChatClient

class ChatViewController: NMessengerViewController {

    /// Paging size.
    private let pageSize = 20
    
    /// Chat input
    var chatInputBar: ChatInputBar!
    
    /// Keyboard height
    fileprivate var keyboardHeight: CGFloat = 0
    
    /// Current page.
    private var currentPage = 1
    
    /// Last added group
    var lastGroup: MessageGroup?
    
    /// Current channel
    var channel: TCHChannel?
    
    /// Chat Action contaner
    var chatActionContainerView = ChatActionContainerView()
    
    /// Datasource
    var messages: [Message] = []
    
    /// Status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Left navigation button
    lazy var leftNavigationButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "cal"), style: .plain, target: self, action: #selector(onLeftNavigationButton))
        button.tintColor = UIColor.white
        
        return button
    }()
    
    /// Right navigation button
    lazy var rightNavigationButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "user_profile"), style: .plain, target: self, action: #selector(onRightNavigationButton))
        button.tintColor = UIColor.white
        
        return button
    }()
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Initial controller setup
        initialSetup()
        
        /// Converastion setup
        conversationUISetup()
        
        /// Fetch messages
        fetchMessages()
        
        /// Keyobard notifications
        addKeyboardWillShowNotification()
        addKeyboardWillHideNotification()
    }
    
    // MARK: - Chat input bar
    override func getInputBar()-> InputBarView {
        
        let inputBar = ChatInputBar(controller: self)
        
        /// Input delegate
        inputBar.delegate = self
        self.chatInputBar = inputBar
        
        return inputBar
    }
    
    // MARK: - Datasource fetch
    /// Messages from clark
    func fetchMessages() {
        
        guard let channelID = Config.channelID else {
            print("WARNING: NO CHANNEL")
            /// Show error
            return
        }
        
        SVProgressHUD.show()
        /// Fetch messages + create cells for current controller
        fetchMessageCells(for: channelID, start: pageSize * currentPage, offset: pageSize).then { groups, messages-> Void in
            
            /// Update controller with messages
            DispatchQueue.main.async {
                if self.messengerView.allMessages().isEmpty { //If there are no messages we have to use the add messages function, otherwise to add new chats to the top, we use endBatchFetch
                    self.messengerView.addMessages(groups, scrollsToMessage: false)
                    
                    self.messengerView.scrollToLastMessage(animated: false)
                    
                    self.lastGroup = groups.last
                }
                else {
                    /// Finish updates
                    self.messengerView.endBatchFetchWithMessages(groups)
                }
            }
            
            /// Update action view
            let lastMessage = messages.last
            if let lastMessage = lastMessage {
                
                /// Update Action controller with message
                self.chatActionContainerView.message = lastMessage
                
                /// Update imput with message
                self.chatInputBar.isEnabled = !(lastMessage.blocking?.boolValue ?? false)
            }
            
            /// Dismiss
            SVProgressHUD.dismiss()
            }.catch { error in
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - Conversation UI setup
    private func conversationUISetup() {
        
        /// Bubble UI
        sharedBubbleConfiguration = ClarkBubblesConfiguration()
        
        /// Messenger view
        messengerView.delegate = self
        messengerView.doesBatchFetch = true
        
        /// Convesation delegate
        let conversationMan = ConversationManager.shared
        conversationMan?.delegate = self
        
        /// Chat Action Container Layout
        view.addSubview(chatActionContainerView)
        chatActionContainerView.delegate = self
    }
    
    // MARK: - Initial setup
    private func initialSetup() {
     
        /// Background setup
        view.backgroundColor = UIColor.white
        
        /// Logo
        setNavigationImage(#imageLiteral(resourceName: "nav_logo"))
        
        let config = Config.shared
        
        /// Left item
        navigationItem.leftBarButtonItem = leftNavigationButton
        navigationItem.leftBarButtonItem?.isEnabled = config.currentTutor != nil
        
        /// Right item
        navigationItem.rightBarButtonItem = rightNavigationButton
        navigationItem.rightBarButtonItem?.isEnabled = config.currentTutor != nil
    }
    
    // MARK: - Actions
    func onLeftNavigationButton() {
        
    }
    
    func onRightNavigationButton() {
        
        /// Safety check
        let config = Config.shared
        guard let tutor = config.currentTutor else {
            return
        }
        
        /// Account flow
        let accountVC = AccountViewController(tutor: tutor)
        pushVC(accountVC)
    }
    
    // MARK: - Keyboard notifications
    override func keyboardWillShowWithFrame(_ frame: CGRect) {
        
        keyboardHeight = frame.height
        
        /// Update chat action position
        updateChatActionViewPosition(frame.height)
    }
    
    override func keyboardWillHideWithFrame(_ frame: CGRect) {
        
        /// Update chat action position
        updateChatActionViewPosition()
    }
}

// MARK: - Conversation manager delegate
extension ChatViewController: ConversationManagerDelegate {
    
    /// Called when channel synchronized
    func channelSynchronized(_ channel: TCHChannel) {
        
        //// Current channel
        self.channel = channel
    }
    
    /// Called when message added to channel
    internal func messageAdded(for channel: TCHChannel, message: Message) {
        
        /// Update datasource
        messages.append(message)
        
        let lastMessage = messages.last
        
        // Set all messages as consumed
        channel.messages.setAllMessagesConsumed()
        
        var messageTimestamp = MessageSentIndicator()
        
        /// Create timestamp
        messageTimestamp = Message.createTimestamp(message, previousMessage: lastMessage)
        if let text = messageTimestamp.messageSentText, text.length > 0 {
            
            let newTimestampGroup = self.createMessageGroup()
            newTimestampGroup.addMessageToGroup(messageTimestamp, completion: nil)
            
            messengerView.addMessage(newTimestampGroup, scrollsToMessage: true)
        }
        
        postText(message.body, isIncoming: message.isReceiver)
    }
}

// MARK: - ChatInputBarDelegate
extension ChatViewController: ChatInputBarDelegate {
    
    /// Called when bar text changed
    func inputBar(_ inputBar:ChatInputBar, textChanged: String) {
        
        /// Update position
        updateChatActionViewPosition(keyboardHeight)
    }
    
    /// Called when send button pressed
    func inputBar(_ inputBar:ChatInputBar, sendText: String) {
        
        /// Check if length > 0
        guard sendText.length > 0 else {
            return
        }
        
        /// Send to channel
        let msg = channel?.messages.createMessage(withBody: sendText)
        channel?.messages.send(msg) { result in }
    }
}

// MARK: - ChatActionContainerViewDelegate
extension ChatViewController: ChatActionContainerViewDelegate {
    
    /// Called when action selected
    func containerView(_ containerView: ChatActionContainerView, selectedAction: QuickAction, message: Message) {
        
        print(selectedAction)
    }
    
    /// Called when reply selected
    func containerView(_ containerView: ChatActionContainerView, selectedReply: QuickReply, message: Message) {
        
        /// Send to channel
        let msg = channel?.messages.createMessage(withBody: selectedReply.body)
        channel?.messages.send(msg) { result in }
    }
    
    /// Called when type changed to visible
    func containerView(_ containerView: ChatActionContainerView, changedTo type: ChatActionContainerViewType) {
        
        /// Update position
        updateChatActionViewPosition()
    }
    
    /// Update actionContainer based on input bar position
    func updateChatActionViewPosition(_ yPos: CGFloat = 0) {
        
        /// Update table view inset
        messengerView.messengerNode.view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: chatActionContainerView.contentHeight + inputBarView.frame.height, right: 0)
        
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
}
