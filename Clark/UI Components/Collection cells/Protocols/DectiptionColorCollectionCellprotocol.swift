//
//  DectiptionColorCollectionCellprotocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/3/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol DectiptionColorCollectionCellprotocol {
    
    /// Description color
    var descriptionColor: UIColor { get }
    
    /// Text
    var descriptionText: String! { get set }
    
    /// Description label
    var descriptionLabel: UILabel { get set }
}

extension DectiptionColorCollectionCellprotocol where Self: UICollectionViewCell {
    
    /// Generate description label
    func generateDescriptionLabel()-> UILabel {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .right
        label.textColor = descriptionColor
        label.font = UIFont.defaultFont(size: 18)
        
        return label
    }
    
    /// Description label layout
    func descriptionLabelLayout() {
        
        /// Decsription label
        addSubview(descriptionLabel)
        
        /// Description label layout
        descriptionLabel.snp.updateConstraints { maker in
            maker.right.equalTo(self).offset(-24)
            maker.width.equalTo(100)
            maker.centerY.equalTo(self)
            maker.height.equalTo(self)
        }
    }
}
