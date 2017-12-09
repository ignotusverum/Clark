//
//  ClientsCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class ClientsCollectionViewCell: UICollectionViewCell {
    
    /// Student object
    var student: Student! {
        didSet {
            
            /// Initials
            initialsLabel.text = student.initials
            
            /// Full name label
            fullNameLabel.text = student.fullName
            
            /// Session date
            sessionDateLabel.text = student.sessionsArray.first?.localStartTime() ?? "No sessions scheduled"
        }
    }
    
    /// Divider view
    lazy var dividerView: UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
        
        return view
    }()
    
    /// Initials label
    lazy var initialsLabel: UILabel = {
       
        /// Label setup
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.defaultFont(size: 16)
        
        /// Background color
        label.backgroundColor = UIColor.trinidad
        label.textColor = UIColor.white
        
        return label
    }()
    
    /// Full name label
    lazy var fullNameLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.defaultFont(size: 17)
        
        return label
    }()
    
    /// Next session date
    lazy var sessionDateLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.defaultFont()
        
        label.textColor = UIColor.lightGray
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        
        /// Initials
        addSubview(initialsLabel)
        
        /// Full name
        addSubview(fullNameLabel)
        
        /// Session date
        addSubview(sessionDateLabel)
        
        /// Divider view
        addSubview(dividerView)
        
        /// Initial layout
        initialsLabel.snp.updateConstraints { maker in
            maker.centerY.equalTo(self)
            maker.left.equalTo(24)
            maker.width.equalTo(36)
            maker.height.equalTo(36)
        }
        
        /// Divider view layout
        dividerView.snp.updateConstraints { maker in
            maker.bottom.equalTo(self)
            maker.width.equalTo(self).offset(-48)
            maker.height.equalTo(0.5)
            maker.centerX.equalTo(self)
        }
        
        /// Full name layout
        fullNameLabel.snp.updateConstraints { maker in
            maker.centerY.equalTo(self).offset(-5 - 6)
            maker.width.equalTo(self)
            maker.left.equalTo(36 + 24 + 16)
            maker.height.equalTo(20)
        }
        
        /// Session date label layout
        sessionDateLabel.snp.updateConstraints { maker in
            maker.centerY.equalTo(self).offset(5 + 6)
            maker.width.equalTo(self)
            maker.left.equalTo(36 + 24 + 16)
            maker.height.equalTo(20)
        }
        
        /// Rounding
        initialsLabel.clipsToBounds = true
        initialsLabel.layer.cornerRadius = 18
    }
}
