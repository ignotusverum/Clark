//
//  TitleAccessoryCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/31/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class TitleAccessoryCell: UICollectionViewCell, SimpleTitleCellProtocol, AccessoryCellProtocol {
    
    /// Accessory image
    lazy var accessoryImageView: UIImageView = self.generateAccessoryImage()
    
    /// Text
    var text: String! {
        didSet {
            /// Title setup
            simpleTitleLabel.text = text
            
            /// Update layout
            layoutSubviews()
        }
    }
    
    /// Text color setup
    var textColor: UIColor {
        return UIColor.trinidad
    }
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Accessory layout
        accessoryLayout()
        
        /// Title layout
        simpleTitleLayout()
    }
}
