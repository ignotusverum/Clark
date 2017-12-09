//
//  ActionSheetCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import SnapKit

class ActionSheetCollectionViewCell: UICollectionViewCell {
    
    /// Action model
    var actionModel: ActionSheetModel!
    
    /// Action button
    lazy var button: UIButton = {
        
        let button = UIButton(frame: .zero)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    /// Title label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.defaultFont(size: 10)
        label.textColor = UIColor.black
        
        return label
    }()
    
    // MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Button
        addSubview(button)
        
        /// Set image
        button.setImage(actionModel.image, for: .normal)
        
        /// Title label
        addSubview(titleLabel)
        titleLabel.text = actionModel.title.capitalizedFirst()
        
        /// Action button layout
        button.snp.updateConstraints { maker in
            maker.height.equalTo(64)
            maker.width.equalTo(64)
            maker.centerX.equalTo(self)
            maker.centerY.equalTo(self)
        }
        
        /// Title button layout
        titleLabel.snp.updateConstraints { maker in
            maker.height.equalTo(20)
            maker.top.equalTo(button).offset(button.frame.height + 6)
            maker.centerX.equalTo(self)
            maker.width.equalTo(self)
        }
        
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.width / 2
    }
}
