//
//  AccountHeaderCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class AccountHeaderCollectionViewCell: UICollectionViewCell {
    
    /// Tutor model
    var tutor: Tutor! {
        didSet {
            
            /// Name setup
            nameLabel.text = tutor.fullName
            
            /// Bio Setup
            bioLabel.text = tutor.bio
            
            /// Initials setup
            initialsLabel.text = tutor.initials
        }
    }
    
    /// Name label
    lazy var nameLabel: UILabel = {
       
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.AvenirNextDemiBold(size: 28)
        
        return label
    }()
    
    /// Bio label
    lazy var bioLabel: UILabel = {
        
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.font = UIFont.AvenirNextRegular(size: 15)
        
        return label
    }()
    
    /// Initials label
    lazy var initialsLabel: UILabel = {
       
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.AvenirNextRegular(size: 34)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        /// Name Label
        addSubview(nameLabel)
        
        /// Bio Label
        addSubview(bioLabel)
        
        /// Initial label
        addSubview(initialsLabel)
        
        /// Initials label layout
        initialsLabel.snp.updateConstraints { maker in
            maker.height.equalTo(88)
            maker.width.equalTo(88)
            maker.centerX.equalTo(self)
            maker.centerY.equalTo(self)
        }
        
        /// BIO label layout
        bioLabel.snp.updateConstraints { maker in
            maker.top.equalTo(initialsLabel).offset(2)
            maker.left.equalTo(8)
            maker.right.equalTo(-8)
        }
        
        /// Name label layout
        nameLabel.snp.updateConstraints { maker in
            maker.top.equalTo(nameLabel).offset(2)
            maker.height.equalTo(40)
            maker.left.equalTo(8)
            maker.right.equalTo(-8)
            maker.bottom.equalTo(-12)
        }
        
        /// Layers
        bioLabel.layer.borderWidth = 1
        bioLabel.layer.borderColor = UIColor.white.cgColor
        bioLabel.layer.cornerRadius = bioLabel.bounds.width / 2
    }
}
