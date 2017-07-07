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
    
    /// Current page.
    private var currentPage = 1
    
    /// Datasource
    var messages: [TCHMessage] = []
    
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
        ConversationManager.fetchMessageCells(for: channelID, start: pageSize * currentPage, offset: pageSize, controller: self, configuration: sharedBubbleConfiguration).then { cells, messages-> Void in
            
            SVProgressHUD.dismiss()
            }.catch { error in
                print(error.localizedDescription)
                SVProgressHUD.dismiss()
        }
    }
    
    // MARK: - Conversation UI setup
    private func conversationUISetup() {
        
        /// Bubble UI
        sharedBubbleConfiguration = SimpleBubbleConfiguration()
        
        /// Messenger view
        messengerView.delegate = self
        messengerView.doesBatchFetch = true
        
        /// Convesation delegate
        let conversationMan = ConversationManager.shared
        conversationMan?.delegate = self
    }
    
    // MARK: - Initial setup
    private func initialSetup() {
     
        /// Background setup
        view.backgroundColor = UIColor.white
        
        /// Logo
        setNavigationImage(#imageLiteral(resourceName: "nav_logo"))
        
        /// Left item
        navigationItem.leftBarButtonItem = leftNavigationButton
        
        /// Right item
        navigationItem.rightBarButtonItem = rightNavigationButton
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
    
    // MARK: - NMessenger overrides
    fileprivate func postText(_ message: MessageNode) {
        messengerView.addMessage(message, scrollsToMessage: true)
    }
}

// MARK: - Conversation manager delegate
extension ChatViewController: ConversationManagerDelegate {
    internal func messageAdded(for channel: TCHChannel, message: TCHMessage) {
        
        // Set all messages as consumed
        channel.messages.setAllMessagesConsumed()
        
        // Text node params
        let textContentNode = TextContentNode(textMessageString: message.body!, currentViewController: self, bubbleConfiguration: self.sharedBubbleConfiguration)
        
        /// Create mesasge node
        let messageNode = MessageNode(content: textContentNode)
        messageNode.cellPadding = messagePadding
        messageNode.currentViewController = self
        
        // Checking is author
        messageNode.isIncomingMessage = message.isReceiver
        
        let lastMessage = messages.last
        
        var messageTimestamp = MessageSentIndicator()
        
        /// Create timestamp
        messageTimestamp = TCHMessage.createTimestamp(message, previousMessage: lastMessage)
        if let text = messageTimestamp.messageSentText, text.length > 0 {
            
            messengerView.addMessage(messageTimestamp, scrollsToMessage: false)
        }
        
        /// Update insets
        automaticallyAdjustsScrollViewInsets = false
        
        /// Update datasource
        messages.append(message)
        
        /// Update UI
        postText(messageNode)
    }
}
