//
//  ChatViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import NMessenger
import TwilioChatClient

class ChatViewController: NMessengerViewController {

    /// Paging size.
    private let pageSize = 20
    
    /// Current page.
    private var currentPage = 1
    
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
        conversationSetup()
    }
    
    // MARK: - Conversation UI setup
    private func conversationSetup() {
        
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
}

// MARK: - Conversation manager delegate
extension ChatViewController: ConversationManagerDelegate {
    func messageAddedForChannel(_ channel: TCHChannel, message: TCHMessage) {
        
    }
}
