//
//  SwitcherCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/15/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

protocol SwitcherCellDelegate {
    func switcherChanged(_ switcher: UISwitch, indexPath: IndexPath)
}

class SwitcherCell: UICollectionViewCell, DividerCellProtocol, SimpleTitleCellProtocol {
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Delegate
    var delegate: SwitcherCellDelegate?
    
    /// index path
    var indexPath: IndexPath!
    
    /// Text
    var text: String! {
        didSet {
            
            /// Paragraph
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 7
            
            /// Text update
            simpleTitleLabel.attributedText = NSAttributedString(string: text, attributes: [NSParagraphStyleAttributeName: paragraph])
        }
    }
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    /// Switcher
    lazy var switcher: UISwitch = {
        var radioButton = UISwitch(frame: .zero)
        return radioButton
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Title layout
        addSubview(simpleTitleLabel)
        simpleTitleLabel.textColor = textColor
        
        /// Title label layout
        simpleTitleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(25)
            maker.right.equalTo(self).offset(-95)
            maker.height.equalTo(self)
            maker.top.equalTo(self)
        }
        
        /// Radio button
        addSubview(switcher)
        switcher.addTarget(self, action: #selector(switcherChanged(sender:)), for: .valueChanged)
        
        /// Radio button layout
        switcher.snp.updateConstraints { maker in
            maker.right.equalTo(self).offset(-25)
            maker.width.equalTo(60)
            maker.height.equalTo(32)
            maker.centerY.equalTo(self)
        }
    }
    
    // MARK: - Actions
    func switcherChanged(sender: UISwitch) {
        
        /// Delegate call
        delegate?.switcherChanged(sender, indexPath: indexPath)
    }
}
