//
//  SimpleTextCollectionViewHeader.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class SimpleTextCollectionViewHeader: UICollectionReusableView {
    
    /// text
    var text: String? {
        didSet {
            
            /// Setup
            titleLabel.text = text
        }
    }
    
    /// Title label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.defaultFont(style: .semiBold, size: 18)
        
        return label
    }()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Bacgkrdoun color
        backgroundColor = UIColor.clear
        
        /// Title label
        addSubview(titleLabel)
        
        /// Title label layout
        titleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(24)
            maker.right.equalTo(-24)
            maker.top.equalTo(12)
            maker.bottom.equalTo(-12)
        }
    }
}

