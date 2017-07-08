//
//  QuickReplyCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class QuickReplyCollectionViewCell: UICollectionViewCell, QuickActionCellProtocol {
    
    /// Action
    var reply: QuickReply! {
        didSet {
            /// Set body text
            bodyLabel.text = reply.body
        }
    }
    
    /// Body label
    lazy var bodyLabel: UILabel = self.generateBodyLabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 8.0
        backgroundColor = UIColor.trinidad
        
        /// Body label
        addSubview(bodyLabel)
        
        /// Body label layout
        bodyLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
    }
}

