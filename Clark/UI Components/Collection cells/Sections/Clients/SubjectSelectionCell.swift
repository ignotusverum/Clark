//
//  SubjectSelectionCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/28/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

protocol SubjectSelectionCellDelegate {
    func subjectSelected(_ subject: Subject, isSelected: Bool)
}

class SubjectSelectionCell: UICollectionViewCell, DividerCellProtocol, SimpleTitleCellProtocol {
    
    /// Subject object
    var subject: Subject! {
        didSet {
            
            /// Update subject name
            simpleTitleLabel.text = subject.name
            
            /// Update UI
            layoutSubviews()
        }
    }
    
    /// Delegate
    var delegate: SubjectSelectionCellDelegate?
    
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
            maker.height.equalTo(self)
            maker.top.equalTo(self)
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
