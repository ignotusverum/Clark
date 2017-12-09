//
//  ClientDetailsHeaderView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class ClientDetailsHeaderView: UICollectionReusableView {
    
    /// Type
    var type: ClientDetailsSessionsCellType! {
        didSet {
            
            /// Setup title
            titleLabel.text = type.rawValue.uppercasedPrefix(1)
            
            layoutSubviews()
        }
    }
    
    /// Title label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.black.withAlphaComponent(0.44)
        label.font = UIFont.defaultFont(style: .medium, size: 14)
        
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
            maker.top.equalTo(24)
            maker.bottom.equalTo(-12)
        }
    }
}
