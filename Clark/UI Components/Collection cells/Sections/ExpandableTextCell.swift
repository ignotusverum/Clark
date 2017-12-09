//
//  ExpandableTextCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/15/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

protocol ExpandableTextCellDelegate {
    
    /// Did expand label
    func didExpand(indexPath: IndexPath)
    
    /// Did collapse label
    func didCollapse(indexPath: IndexPath)
}

class ExpandableTextCell: UICollectionViewCell, DividerCellProtocol, TitleCellProtocol {
    
    var indexPath: IndexPath!
    
    /// Delegate
    var delegate: ExpandableTextCellDelegate?
    
    /// Session
    var body: String? {
        didSet {
            
            /// Update label text
            detailsLabel.text = body
            
            /// Update layout
            layoutSubviews()
        }
    }
    
    /// Expandable Label
    lazy var detailsLabel: UILabel = {
        
        let label = UILabel()
        
        return label
    }()
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Title text
    var titleText: String! {
        didSet {
            
            /// Title setup
            titleLabel.text = titleText
        }
    }
    
    /// Title label
    lazy var titleLabel: UILabel = self.generateTitleLabel()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider setup
        dividerLayout()
        
        /// Title setup
        titleLabelLayout()
        
        /// Details label
        addSubview(detailsLabel)
        
        /// Details layout
        detailsLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(titleLabel.bottom + 12)
            maker.left.equalTo(self).offset(24)
            maker.right.equalTo(self).offset(-24)
            maker.bottom.equalTo(self).offset(-24)
        }
    }
    
    /// Calculated height
    class func calculatedHeight(text: String?)-> CGFloat{
        
        guard let text = text else {
            return 0
        }
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        let titleHeight: CGFloat = 18 + 24 + 12
        let textHeight: CGFloat = text.heightWithConstrainedWidth(screenWidth - 48, font: UIFont.defaultFont(size: 18))
        
        return text.length > 0 ? titleHeight + textHeight + 24 : 0
    }
}

/// Expanding label delegate
extension ExpandableTextCell: ExpandableLabelDelegate {
    
    func didExpandLabel(_ label: ExpandableLabel) {
        delegate?.didExpand(indexPath: indexPath)
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        delegate?.didCollapse(indexPath: indexPath)
    }
    
    func willExpandLabel(_ label: ExpandableLabel) {}
    func willCollapseLabel(_ label: ExpandableLabel) {}
}

