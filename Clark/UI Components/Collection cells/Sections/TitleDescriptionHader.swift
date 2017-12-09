//
//  TitleDescriptionHader.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/30/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class TitleDescriptionHader: UICollectionReusableView {
    
    /// text
    var text: String? {
        didSet {
            
            /// Setup
            titleLabel.text = text
        }
    }
    
    /// Description copy
    var descriptionCopy: String? {
        didSet {
            
        }
    }
    
    /// Description label
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.defaultFont(style: .light, size: 18)
        label.textColor = UIColor.messageIncomingColor
        
        return label
    }()
    
    /// Title label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.defaultFont(style: .semiBold, size: 28)
        
        return label
    }()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Bacgkrdoun color
        backgroundColor = UIColor.clear
        
        /// Title label
        addSubview(titleLabel)
        
        /// Description label
        addSubview(descriptionLabel)
        
        /// Title label layout
        titleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(24)
            maker.right.equalTo(-24)
            maker.top.equalTo(12)
            maker.height.equalTo(90)
        }
        
        /// Description label layout
        descriptionLabel.snp.updateConstraints { maker in
            maker.left.equalTo(24)
            maker.right.equalTo(-24)
            maker.top.equalTo(titleLabel).offset(80)
            maker.bottom.equalTo(self)
        }
    }
}

