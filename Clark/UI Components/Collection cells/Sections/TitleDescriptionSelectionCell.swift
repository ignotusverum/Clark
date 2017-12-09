//
//  TitleDescriptionSelectionCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/12/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class TitleDescriptionSelectionCell: UICollectionViewCell, DividerCellProtocol, SimpleTitleCellProtocol {
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Selected
    var isButtonSelected: Bool = false {
        didSet {
            
            /// Update UI
            layoutSubviews()
        }
    }
    
    /// Button
    lazy var button: UIButton = {
        
        let button = UIButton()
        return button
    }()
    
    /// Simple title
    var text: String! {
        didSet {
            
            /// Title
            simpleTitleLabel.text = text
        }
    }
    
    var descriptionText: String! {
        didSet {
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 5
            
            descriptionLabel.attributedText = NSAttributedString(string: descriptionText, attributes: [NSParagraphStyleAttributeName: paragraph])
        }
    }
  
    /// Copy label
    lazy var descriptionLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.defaultFont(style: .light, size: 14)
        label.textColor = UIColor.messageIncomingColor
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    // MARK: - Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider layout
        dividerLayout()
        
        /// Button
        addSubview(button)
        button.snp.updateConstraints { maker in
            maker.centerY.equalTo(self)
            maker.right.equalTo(self).offset(-24)
            maker.width.equalTo(32)
            maker.height.equalTo(32)
        }
        
        /// Update button corner
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        
        /// Title label
        addSubview(simpleTitleLabel)
        simpleTitleLabel.textColor = textColor
        
        /// Title label layout
        simpleTitleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(25)
            maker.right.equalTo(self).offset(-95)
            maker.height.equalTo(20)
            maker.top.equalTo(24)
        }
        
        /// Decsription label
        addSubview(descriptionLabel)
        
        /// Description label layout
        descriptionLabel.snp.updateConstraints { maker in
            maker.top.equalTo(54)
            maker.left.equalTo(24)
            maker.right.equalTo(-95)
            maker.bottom.equalTo(self).offset(-24)
        }
        
        if isButtonSelected {
            
            /// Selected state
            button.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            
            button.tintColor = UIColor.white
            button.setBackgroundColor(UIColor.trinidad, forState: .normal)
            
            return
        }
        
        button.setImage(UIImage(), for: .normal)
        
        /// Unselected state
        button.setBackgroundColor(UIColor.ColorWith(red: 68, green: 68, blue: 68, alpha: 0.1), forState: .normal)
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.ColorWith(red: 68, green: 68, blue: 68, alpha: 0.7).cgColor
    }
}

