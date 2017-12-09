//
//  ActionDescriptionCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class ActionDescriptionCell: UICollectionViewCell, SimpleTitleCellProtocol, AccessoryCellProtocol, DectiptionColorCollectionCellprotocol, DividerCellProtocol {
    
    /// Divider view
    lazy var dividerView: UIView  = self.generateDividerView()
    
    /// Accessory image
    lazy var accessoryImageView: UIImageView = self.generateAccessoryImage()
    
    /// Description Text
    var descriptionText: String! {
        didSet {
            
            /// Description label layout
            descriptionLabel.numberOfLines = 2
            descriptionLabel.textAlignment = .left
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 7
            
            descriptionLabel.attributedText = NSAttributedString(string: descriptionText, attributes: [NSParagraphStyleAttributeName: paragraph, NSForegroundColorAttributeName: UIColor.messageIncomingColor, NSFontAttributeName: UIFont.defaultFont(style: .light, size: 14)])
            
            /// Update layout
            layoutSubviews()
        }
    }
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    /// Description color
    var descriptionColor: UIColor {
        return UIColor.messageIncomingColor
    }
    
    /// Description label
    lazy var descriptionLabel: UILabel = self.generateDescriptionLabel()
    
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
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider layout
        dividerLayout()
        
        /// Accessory layout
        accessoryLayout()
        
        addSubview(simpleTitleLabel)
        simpleTitleLabel.textColor = UIColor.trinidad
        /// Title layout
        simpleTitleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(25)
            maker.right.equalTo(self).offset(-25)
            maker.height.equalTo(20)
            maker.top.equalTo(25)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.updateConstraints { maker in
            maker.left.equalTo(25)
            maker.right.equalTo(self).offset(-45)
            maker.top.equalTo(12)
            maker.height.equalTo(self)
        }
    }
}
