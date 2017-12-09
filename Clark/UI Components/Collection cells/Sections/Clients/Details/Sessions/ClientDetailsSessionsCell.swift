//
//  ClientDetailsSessionsCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

enum ClientDetailsSessionsCellType: String {
    case past = "Past"
    case upcoming = "Upcoming"
}

class ClientDetailsSessionsCell: UICollectionViewCell, DividerCellProtocol, AccessoryCellProtocol, DectiptionColorCollectionCellprotocol, TitleCellProtocol {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Description
            descriptionText = session.statusString?.uppercasedPrefix(1)
            
            /// Check if current year
            let currentYear = Date().year
            let sessionYear = session.startTime?.year ?? 0
            
            if currentYear >= sessionYear {
                /// Title
                titleText = session.localStartTime(format: "E, MMM d")
            }
            else {
            
                /// Show year
                titleLabel.text = session.localStartTime(format: "E, MMM d, yyyy")
            }
            
            /// Update layout
            layoutSubviews()
        }
    }
    
    /// Accessory image
    lazy var accessoryImageView: UIImageView = self.generateAccessoryImage()
    
    /// Accessory tint
    var accessoryTintColor: UIColor {
        return SessionStatus.colors[self.session.status]!
    }
    
    /// Type
    var type: ClientDetailsSessionsCellType!
    
    /// Description color
    var descriptionColor: UIColor {
        return SessionStatus.colors[self.session.status]!
    }
    
    /// Title text
    var titleText: String! {
        didSet {
            /// Title
            titleLabel.text = titleText
        }
    }
    
    /// Title label
    lazy var titleLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.defaultFont(size: 18)
        
        return label
    }()
    
    /// Text
    var descriptionText: String! {
        didSet {
            
            descriptionLabel.text = descriptionText
        }
    }
    
    /// Description label
    lazy var descriptionLabel: UILabel = self.generateDescriptionLabel()
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Setup divider
        dividerLayout()
        
        /// Accessory setup
        accessoryLayout()
        
        /// Title setup
        titleLabelLayout()
        
        /// Decsription label
        addSubview(descriptionLabel)
        
        /// Description label layout
        descriptionLabel.snp.updateConstraints { maker in
            maker.right.equalTo(self).offset(-8 - 8 - 24)
            maker.width.equalTo(100)
            maker.centerY.equalTo(self)
            maker.height.equalTo(self)
        }
    }
}
