//
//  TitleDescriptionCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/15/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class TitleBottomDescriptionSelectionCell: UICollectionViewCell, DividerCellProtocol, SimpleTitleCellProtocol {
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    var shouldHaveTopInset: Bool = false
    
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

        /// Title label
        addSubview(simpleTitleLabel)
        simpleTitleLabel.textColor = textColor
        
        let titleInset: CGFloat = shouldHaveTopInset ? 24 : 0
        /// Title label layout
        simpleTitleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(25)
            maker.right.equalTo(self).offset(-95)
            maker.height.equalTo(20)
            maker.top.equalTo(titleInset)
        }
        
        /// Decsription label
        addSubview(descriptionLabel)
        
        let descriptionInset: CGFloat = shouldHaveTopInset ? 54 : 34
        /// Description label layout
        descriptionLabel.snp.updateConstraints { maker in
            maker.top.equalTo(descriptionInset)
            maker.left.equalTo(24)
            maker.right.equalTo(-95)
            maker.bottom.equalTo(self).offset(-24)
        }
    }
}
