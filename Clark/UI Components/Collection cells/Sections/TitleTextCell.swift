//
//  TitleTextCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/16/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class TitleTextCell: UICollectionViewCell, DividerCellProtocol, SimpleTitleCellProtocol, TitleCellProtocol {
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Simple title
    var text: String! {
        didSet {
            
            /// Title
            simpleTitleLabel.text = text
        }
    }
    
    /// Title text
    var titleText: String! {
        didSet {
            
            /// Set title
            titleLabel.text = titleText
        }
    }
    
    /// Title label
    lazy var titleLabel: UILabel = self.generateTitleLabel()
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    // MARK: - Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider layout
        dividerLayout()
        
        /// Title layout
        titleLabelLayout()
        
        /// Simple layout
        addSubview(simpleTitleLabel)
        
        simpleTitleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(45 + 12)
            maker.left.equalTo(self).offset(24)
            maker.right.equalTo(self).offset(-24)
            maker.bottom.equalTo(self).offset(-12)
        }
    }
}
