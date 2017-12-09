//
//  SignOutCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class SignOutCollectionViewCell: UICollectionViewCell {
    
    /// Sign out button
    lazy var signOutButton: UIButton = {
        
        let button = UIButton(frame: .zero)
        button.setTitle("SIGN OUT", for: .normal)
        button.setTitleColor(UIColor.inActiveStateColor, for: .normal)
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Sign out button
        addSubview(signOutButton)
        
        signOutButton.layer.borderWidth = 2
        signOutButton.layer.cornerRadius = 8
        signOutButton.layer.borderColor = UIColor.inActiveStateColor.cgColor
        
        /// Sign out button layout
        signOutButton.snp.updateConstraints { maker in
            maker.left.equalTo(15)
            maker.right.equalTo(-15)
            maker.height.equalTo(self)
            maker.centerY.equalTo(self)
        }
    }
}
