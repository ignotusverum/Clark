//
//  HomeViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/17/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import NMessenger
import SVProgressHUD
import TwilioChatClient
import EZSwiftExtensions

class HomeViewController: NMessengerViewController, ClarkChatProtocol {
    
    /// Paging size.
    var pageSize: Int {
        return 20
    }
    
    /// Chat input
    lazy var chatInputBar: ChatInputBar = {
        return ChatInputBar(controller: self, enableLeftAction: true)
    }()
    
    /// Typing indicator
    var typingIndicator: GeneralMessengerCell?
    
    /// Keyboard height
    var keyboardHeight: CGFloat = 0
    
    /// Action sheet view
    var actionSheetView = ActionSheetView()
    
    /// Autocomplete view
    var autocompleteView = AutocompleteView()
    
    /// Current page.
    var currentPage = 1
    
    /// Last added group
    var lastGroup: MessageGroup?
    
    /// Delegate
    var delegate: LargeNavigationControllerDelegate?
    
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
    
    // MARK: - Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Analytics
        Analytics.screen(screenId: .s3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Convesation delegate
        let conversationMan = ConversationManager.shared
        conversationMan?.delegate = self
        
        channel = conversationMan?.channel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Push update
        ConversationManager.registerForPushNotifications(UIApplication.shared)
        
        /// Initial controller setup
        initialSetup()
        
        /// Conversation UI setup
        conversationUISetup()
        
        /// Fetch messages
        fetchMessages(showLoading: true)
        
        /// Keyobard notifications
        addKeyboardWillShowNotification()
        addKeyboardWillHideNotification()
        
        /// Temp solution
        let setCollectionViewInsets = Notification.Name("setCollectionViewInsets")
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCollectionViewInsets(_:)), name: setCollectionViewInsets, object: nil)
        
        // Setup banner code
        BannerManager.manager.viewController = self
        BannerManager.manager.errorMessageHiddenForCategory = { category in
            print(category)
        }
        
        /// Setup message parser logic
        let messageParser = MessageParser.shared
        messageParser.delegate = self
    }
    
    // MARK: - Chat input bar
    override func getInputBar()-> InputBarView {
        
        /// Input delegate
        chatInputBar.delegate = self
        
        return chatInputBar
    }
    
    // MARK: - Conversation UI setup
    func conversationUISetup() {
        
        /// Bubble UI
        sharedBubbleConfiguration = ClarkBubblesConfiguration()
        
        /// Messenger view
        messengerView.delegate = self
        messengerView.doesBatchFetch = true
        
        /// Chat Action Container Layout
        view.addSubview(chatActionContainerView)
        chatActionContainerView.delegate = self
        
        /// Autocomplete setup
        autocompleteViewLayout(false)
        
        /// Hide keyboard
        view.endEditing(true)
        
        /// Action sheet view layout
        actionSheetView.isOpen = false
    }
    
    /// Fetch more messages
    func batchFetchContent() {
        
        currentPage += 1
        fetchMessages(showLoading: false, loadMore: true)
    }
    
    // MARK: - Initial setup
    func initialSetup() {
        
        /// Background setup
        view.backgroundColor = UIColor.white
        
        /// Logo
        setNavigationImage(#imageLiteral(resourceName: "nav_logo"))
    }
    
    /// Action sheet layout setup
    fileprivate func actionSheetViewLayout() {
        
        /// Check if action view contains in hierarchy
        if !view.subviews.contains(actionSheetView) {
            view.addSubview(actionSheetView)
            
            /// Set delegate
            actionSheetView.delegate = self
            
            /// Update layout on tap
            actionSheetView.onTap({
                
                /// Update button
                self.chatInputBar.isActionOpened = false
                
                /// Hide keyboard
                self.view.endEditing(true)
                
                self.actionSheetViewLayout()
            })
        }
        
        UIView.animate(withDuration: 0.2) {
            
            /// Setup kickoff layout
            let bottomPosition = self.actionSheetView.isOpen ? -43 : self.view.frame.height
            self.actionSheetView.snp.updateConstraints({ make in
                make.bottom.equalTo(bottomPosition)
                make.left.equalTo(self.view)
                make.right.equalTo(self.view)
                make.height.equalTo(self.view.frame.height)
            })
            
            self.view.layoutSubviews()
        }
    }
    
    fileprivate func autocompleteViewLayout(_ isOpen: Bool) {
        
        /// Check if action view contains in hierarchy
        if !view.subviews.contains(autocompleteView) {
            view.addSubview(autocompleteView)
            
            /// Delegate
            autocompleteView.delegate = self
            autocompleteView.alpha = 0
        }
        
        /// Check if data ready
        if autocompleteView.state != .empty {
        
            autocompleteView.isHidden = false
            
            autocompleteView.isPresented = isOpen
            let bottomLayout = -inputBarView.frame.height
            
            /// Autocomplete layout
            autocompleteView.snp.updateConstraints { maker in
                maker.left.equalTo(self.view)
                maker.right.equalTo(self.view)
                maker.bottom.equalTo(bottomLayout)
                maker.height.equalTo(120)
            }
            
            /// Update borders
            autocompleteView.addBorderTop(size: 0.5, color: UIColor.lightGray.withAlphaComponent(0.4))
            autocompleteView.addBorderBottom(size: 0.5, color: UIColor.lightGray.withAlphaComponent(0.4))
            
            /// Presenting animation
            if isOpen {
                UIView.animate(withDuration: 0.5) {
                    self.autocompleteView.alpha = 1
                }
            }
            else if autocompleteView.state == .empty {
                autocompleteView.alpha = 0
            }
            
            /// Update inset
            messengerView.messengerNode.view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: chatActionContainerView.contentHeight + inputBarView.frame.height + 44, right: 0)
        }
        else {
            
            autocompleteView.isHidden = true
            
            /// Update inset
            messengerView.messengerNode.view.contentInset = .zero
        }
    }
    
    // MARK: - Keyboard notifications
    override func keyboardWillShowWithFrame(_ frame: CGRect) {
        
        /// Close view
        actionSheetView.isOpen = false
        chatInputBar.isActionOpened = false
        
        /// Udpate layout
        actionSheetViewLayout()
        
        keyboardWillShow(frame: frame)
        
        /// Show autocomplete
        autocompleteViewLayout(true)
    }
    
    override func keyboardWillHideWithFrame(_ frame: CGRect) {
        keyboardWillHide(frame: frame)
        
        /// Hide autocomplete
        autocompleteViewLayout(false)
        
        /// Update tabbar
        view.endEditing(true)
    }
    
    // MARK: - Wake
    func applicationDidWake(_ notification: NSNotification) {
        fetchMessages(showLoading: false, loadMore: true)
    }
}

extension HomeViewController: AutocompleteViewDelegate {
    func autocomplete(valid:Bool, newString:String, intent:String?) {
        
        /// Update tabbar with valid text
        autocompleteView.updateWith(text: newString)
        chatInputBar.textInputView.text = newString
        chatInputBar.textInputView.textColor = UIColor.dodgerBlue
    }
    
    /// Called when should animate presentation
    func stateChanged(shouldShow: Bool) {
        autocompleteViewLayout(shouldShow)
    }
}

// MARK: - Action sheet delegate
extension HomeViewController: ActionSheetViewDelegate {
    func onAction(_ action: ActionSheetModel) {
        
        /// Analytics
        Analytics.trackEventWithID(.s3_7, eventParams: ["buttonType": action.type.rawValue])
        
        ez.runThisAfterDelay(seconds: 0.1) {

            /// Check type
            switch action.type {
            case .feedback:
                self.delegate?.switchTo(.schedule)
                
            case .session:
                
                let createVC = ScheduleRouteHandler.createTransition(student: nil)
                createVC.onFlowCompleted({ session in
                    /// Safety check
                    guard let session = session else {
                        return
                    }
                    
                    let title = session.student?.firstName != nil ? "Session with \(session.student!.firstName!) created successfully" : "Session created successfully"
                    DefaultNotificationView.showNotification(controller: self, title: title, image: #imageLiteral(resourceName: "schedule_navigation_icon"))
                })
                
                self.presentVC(createVC)
                
            case .student:
                
                let createVC = ClientsRouteHandler.createTransition()
                createVC.1.onFlowCompleted({ student in
                    /// Safety check
                    guard let student = student else {
                        return
                    }
                    
                    let title = student.fullName != nil ? "\(student.fullName!) addedd successfully" : "Student added successfully"
                    DefaultNotificationView.showNotification(controller: self, title: title, image: #imageLiteral(resourceName: "client_navigation_icon"))
                })
                
                self.presentVC(createVC.0)
                
            case .cancel:
                
                self.chatInputBar.textInputView.becomeFirstResponder()
                
                /// Make smooth animatin
                ez.runThisAfterDelay(seconds: 0.2, after: {
                    self.autocompleteView.updateWith(text: "Cancel")
                    self.autocompleteViewLayout(true)
                })
                
            case .reschedule:
                
                self.chatInputBar.textInputView.becomeFirstResponder()
                
                /// Make smooth animatin
                ez.runThisAfterDelay(seconds: 0.2, after: {
                    self.autocompleteView.updateWith(text: "Reschedule")
                    self.autocompleteViewLayout(true)
                })
            case .profile:
                UIApplication.shared.open(URL(string: "https://tutors.hiclark.com/start")!, options: [:], completionHandler: nil)
            }
            
            /// Close view
            self.actionSheetView.isOpen = false
            self.chatInputBar.isActionOpened = false
            
            /// Hide keyboard
            self.view.endEditing(true)
            
            /// Udpate layout
            self.actionSheetViewLayout()
        }
    }
}

// MARK: - Conversation manager delegate
extension HomeViewController: ConversationManagerDelegate {
    
    /// Called when channel synchronized
    func channelSynchronized(_ channel: TCHChannel) {
        
        //// Current channel
        self.channel = channel
        
        /// Fetch messages
        fetchMessages(showLoading: true)
    }
    
    // MARK: - Temp inset handlers
    func setCollectionViewInsets(_ notification: Notification) {
        guard let height = notification.userInfo?["bannerHeight"] as? CGFloat else {return}
        updateInset(topInset: height)
    }
}

// MARK: - ChatInputBarDelegate
extension HomeViewController: ChatInputBarDelegate {
    
    /// Called when keyboard presented for input
    func inputActive(_ inpuBar: ChatInputBar) {
        messengerView.scrollToLastMessage(animated: true)
    }
    
    /// Called when bar text changed
    func inputBar(_ inputBar:ChatInputBar, textChanged: String) {
        
        /// Update color to default
        chatInputBar.textInputView.textColor = UIColor.black
        
        /// Update autocomplete view
        autocompleteView.updateWith(text: textChanged)
        
        /// Update position
        updateChatActionViewPosition(keyboardHeight)
    }
    
    /// Called when send button pressed
    func inputBar(_ inputBar:ChatInputBar, sendText: String) {
        
        /// Check if length > 0
        guard sendText.length > 0 else {
            return
        }
        
        autocompleteView.updateWith(text: "")
        
        /// Send to channel
        sendMessage(sendText)
        
        /// Analyics
        Analytics.trackEventWithID(.s3_3, eventParams: ["body": sendText, "timestamp": Date().toString()])
    }
    
    /// Called when accessory pressed
    func inputBarAccessoryPressed(_ inputBar: ChatInputBar) {
        
        /// Show action sheet with animation
        actionSheetView.isOpen = !actionSheetView.isOpen
        
        /// Hide keyboard
        view.endEditing(true)
        
        /// Update layout
        actionSheetViewLayout()
        
        /// Analytics
        Analytics.trackEventWithID(.s3_8, eventParams: ["isOpen": actionSheetView.isOpen])
    }
}

// MARK: - ChatActionContainerViewDelegate
extension HomeViewController: ChatActionContainerViewDelegate {
    
    /// Called when action selected
    func containerView(_ containerView: ChatActionContainerView, selectedAction: QuickAction, message: Message) {
         containerView_(containerView, selectedAction: selectedAction, message: message)
        
        /// Analytics
        Analytics.trackEventWithID(.s3_5, eventParams: ["body": message.body, "timestamp": message.sent?.toString() ?? ""])
    }
    
    /// Called when reply selected
    func containerView(_ containerView: ChatActionContainerView, selectedReply: QuickReply, message: Message) {
        containerView_(containerView, selectedReply: selectedReply, message: message)
        
        /// Analytics
        Analytics.trackEventWithID(.s3_4, eventParams: ["body": message.body, "timestamp": message.sent?.toString() ?? ""])
    }
    
    /// Called when type changed to visible
    func containerView(_ containerView: ChatActionContainerView, changedTo type: ChatActionContainerViewType) {
        containerView_(containerView, changedTo: type)
    }
}
