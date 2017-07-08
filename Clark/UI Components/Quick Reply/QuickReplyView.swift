//
//  QuickReplyView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol QuickReplyViewDelegate {
    /// Called when action selected
    func actionView(_ actionView: QuickReplyView, selectedAction: QuickReply)
}

class QuickReplyView: UIView, QuickActionViewProtocol {
    
    /// Message
    var message: Message {
        didSet {
            
            /// Hide view if no quick actions
            isHidden = message.quickReplies.count == 0
        }
    }
    
    /// Delegate
    var delegate: QuickReplyViewDelegate?
    
    /// Is open
    var isOpen: Bool = false
    
    /// Collection view
    lazy var collectionView: UICollectionView = self.generateCollection()
    
    // MARK: - Initialization
    init(message: Message) {
        self.message = message
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom setup
    private func customSetup() {
        
        /// Register cells
        collectionView.register(QuickReplyCollectionViewCell.self, forCellWithReuseIdentifier: "\(QuickReplyCollectionViewCell.self)")
        
        /// Collection view
        addSubview(collectionView)
        
        /// Collection setup
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - CollectionView Datasource
extension QuickReplyView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        let action = message.quickReplies[indexPath.row]
        let body = NSAttributedString(string: action.body, attributes: [NSFontAttributeName: UIFont.AvenirNextRegular(size: 17)])
        
        return CGSize(width: body.widthWithConstrainedHeight(35) + 12, height: 35)
    }
}

// MARK: - CollectionView Delegate
extension QuickReplyView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// Pass selected action through delegate
        let reply = message.quickReplies[indexPath.row]
        delegate?.actionView(self, selectedAction: reply)
    }
}

// MARK: - CollectionView Datasource
extension QuickReplyView: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return message.quickReplies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        /// Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(QuickReplyCollectionViewCell.self)", for: indexPath) as! QuickReplyCollectionViewCell
        
        /// Get action
        let reply = message.quickReplies[indexPath.row]
        cell.reply = reply
        
        return cell
    }
}
