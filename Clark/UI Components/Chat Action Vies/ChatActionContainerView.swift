//
//  ChatActionContainerView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

enum ChatActionContainerViewType {
    case action
    case reply
    
    case none
}

protocol ChatActionContainerViewDelegate {
    /// Called when action selected
    func containerView(_ containerView: ChatActionContainerView, selectedAction: QuickAction)
    
    /// Called when reply selected
    func containerView(_ containerView: ChatActionContainerView, selectedReply: QuickReply)
    
    /// Called when type changed to visible
    func containerView(_ containerView: ChatActionContainerView, changedTo type: ChatActionContainerViewType)
}

class ChatActionContainerView: UIView, QuickActionViewProtocol {

    /// Message
    var message: Message! {
        didSet {
            
            /// Type check
            type = message.quickActions.count > 0 ? .action : (message.quickReplies.count > 0 ? .reply : .none)
            
            /// Reload data
            collectionView.reloadData()
            
            if type != .none {
                /// Delegate callback
                delegate?.containerView(self, changedTo: type)
            }
        }
    }
    
    /// Content height
    var contentHeight: CGFloat {
        return type == .none ? 0 : 80
    }
    
    /// View type
    var type: ChatActionContainerViewType! = .none
    
    /// Delegate
    var delegate: ChatActionContainerViewDelegate?
    
    /// Is open
    var isOpen: Bool = false
    
    /// Collection view
    lazy var collectionView: UICollectionView = self.generateCollection()
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero)
        
        /// custom init
        customSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom setup
    private func customSetup() {
        
        /// Register cells
        collectionView.register(QuickReplyCollectionViewCell.self, forCellWithReuseIdentifier: "\(QuickReplyCollectionViewCell.self)")
        collectionView.register(QuickActionViewCollectionViewCell.self, forCellWithReuseIdentifier: "\(QuickActionViewCollectionViewCell.self)")
        
        /// Collection view
        addSubview(collectionView)
        
        /// Collection setup
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Collection layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
    }
}

// MARK: - CollectionView Datasource
extension ChatActionContainerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        let action = message.quickReplies[indexPath.row]
        let body = NSAttributedString(string: action.body, attributes: [NSFontAttributeName: UIFont.AvenirNextRegular(size: 17)])
        
        return CGSize(width: body.widthWithConstrainedHeight(35) + 24, height: 35)
    }
}

// MARK: - CollectionView Delegate
extension ChatActionContainerView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if type == .reply {
            
            /// Pass selected reply through delegate
            let reply = message.quickReplies[indexPath.row]
            delegate?.containerView(self, selectedReply: reply)
        }
        else if type == .action {
            
            /// Pass selected action through delegate
            let action = message.quickActions[indexPath.row]
            delegate?.containerView(self, selectedAction: action)
        }
    }
}

// MARK: - CollectionView Datasource
extension ChatActionContainerView: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return type == .none ? 0 : type == .action ? message.quickActions.count : type == .reply ? message.quickReplies.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        if type == .reply {
        
            /// Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(QuickReplyCollectionViewCell.self)", for: indexPath) as! QuickReplyCollectionViewCell
            
            /// Get reply
            let reply = message.quickReplies[indexPath.row]
            cell.reply = reply
            
            return cell
        }
        
        /// Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(QuickActionViewCollectionViewCell.self)", for: indexPath) as! QuickActionViewCollectionViewCell
        
        /// Get action
        let action = message.quickActions[indexPath.row]
        cell.action = action
        
        return cell
    }
}
