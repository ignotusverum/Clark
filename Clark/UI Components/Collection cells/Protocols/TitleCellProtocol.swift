//
//  TitleCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/3/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation

protocol TitleCellProtocol {
    
    /// Title text
    var titleText: String! { get set }
    
    /// Title label
    var titleLabel: UILabel { get set }
}

extension TitleCellProtocol where Self: UICollectionViewCell {
    
    /// Generate title label
    func generateTitleLabel()-> UILabel {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.defaultFont(style: .medium, size: 14)
        
        return label
    }
    
    /// Title label layout
    func titleLabelLayout() {
        
        /// Add label
        addSubview(titleLabel)
        
        /// Label layout
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(25)
            maker.left.equalTo(self).offset(25)
            maker.width.equalTo(self).offset(-24)
            maker.height.equalTo(20)
        }
    }
}
