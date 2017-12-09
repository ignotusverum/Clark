//
//  SimpleTextCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class SimpleTextCollectionViewCell: UICollectionViewCell, DividerCellProtocol, AccessoryCellProtocol, SimpleTitleCellProtocol {
    
    /// Title text
    var text: String! {
        didSet {
            simpleTitleLabel.text = text
        }
    }
    
    /// Text color
    var textColor: UIColor = UIColor.black {
        didSet {
            /// Update text color
            simpleTitleLabel.textColor = textColor
        }
    }
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    /// Accessory image
    lazy var accessoryImageView: UIImageView = self.generateAccessoryImage()
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider view
        dividerLayout()
        
        /// Accessory view
        accessoryLayout()
        
        /// Title layout
        simpleTitleLayout()
    }
}
