//
//  AccountView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

class AccountView: UIView {
    
    /// Tutor model
    var tutor: Tutor {
        didSet {
            /// Update
            customInit()
            
            /// Layout update
            layoutSubviews()
        }
    }
    
    /// Name label
    lazy var nameLabel: UILabel = {
        
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.defaultFont(style: .semiBold, size: 34)
        
        return label
    }()
    
    /// Bio label
    lazy var bioLabel: UILabel = {
        
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.white.withAlphaComponent(0.6)
        label.font = UIFont.defaultFont(size: 20)
        
        return label
    }()
    
    /// Initials label
    lazy var initialsLabel: UILabel = {
        
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.trinidad
        label.backgroundColor = UIColor.white
        label.font = UIFont.defaultFont(style: .light, size: 44)
        
        return label
    }()
    
    /// Edit button
    lazy var editButton: UIButton = {
       
        let button = UIButton(frame: .zero)
        button.backgroundColor = UIColor.white
        button.setTitle("EDIT", for: .normal)
        button.setTitleColor(UIColor.trinidad, for: .normal)
        button.titleLabel?.font = UIFont.defaultFont(style: .semiBold, size: 17)
        
        button.isUserInteractionEnabled = false
        
        return button
    }()
    
    // MARK: - Initialization
    init(tutor: Tutor) {
        self.tutor = tutor
        super.init(frame: .zero)
        
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("account view not coder init not implemented ")
    }
    
    func customInit() {
        
        /// Clear background
        backgroundColor = UIColor.trinidad
        
        /// Name setup
        nameLabel.text = tutor.fullName
        
        /// Bio Setup
        bioLabel.text = tutor.bio
        
        /// Initials setup
        initialsLabel.text = tutor.initials
    }
    
    // MARK: - Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        /// Name Label
        addSubview(nameLabel)
        
        /// Bio Label
        addSubview(bioLabel)
        
        /// Initial label
        addSubview(initialsLabel)
        
        /// Edit button
        addSubview(editButton)
        
        /// Initials label layout
        initialsLabel.snp.updateConstraints { maker in
            maker.height.equalTo(128)
            maker.width.equalTo(128)
            maker.top.equalTo(42)
            maker.centerX.equalTo(self)
        }
        
        /// Name label layout
        nameLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(128 + 42 + 16)
            maker.height.equalTo(40)
            maker.centerX.equalTo(self)
            maker.width.equalTo(self)
        }
        
        /// BIO label layout
        bioLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(nameLabel.bottom + 2)
            maker.height.equalTo(30)
            maker.centerX.equalTo(self)
            maker.width.equalTo(self)
        }
        
        /// Edit button
        editButton.snp.updateConstraints { maker in
            maker.bottom.equalTo(self).offset(-20)
            maker.height.equalTo(28)
            maker.centerX.equalTo(self)
            maker.width.equalTo(85)
        }
        
        /// Layers - initials
        initialsLabel.layer.cornerRadius = 128 / 2
        initialsLabel.clipsToBounds = true
        
        /// Edit button
        editButton.layer.cornerRadius = 12
    }
}
