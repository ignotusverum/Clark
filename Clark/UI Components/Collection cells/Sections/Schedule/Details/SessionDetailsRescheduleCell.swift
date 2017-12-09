//
//  SessionDetailsRescheduleCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/4/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class SessionDetailsRescheduleCell: UICollectionViewCell, DividerCellProtocol, SimpleTitleCellProtocol, SessionDetailsCellProtocol, AccessoryCellProtocol {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Set text
            text = "Reschedule"
            
            layoutSubviews()
        }
    }
    
    /// Divider
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Text
    var text: String! {
        didSet {
            
            simpleTitleLabel.text = text
        }
    }
    
    /// Color
    var textColor: UIColor  {
        return UIColor.trinidad
    }
    
    /// Accessory image
    lazy var accessoryImageView: UIImageView = self.generateAccessoryImage()
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    /// Description color
    var descriptionColor: UIColor {
        return UIColor.trinidad
    }
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider view
        dividerLayout()
        
        /// Accessory
        accessoryLayout()
        
        /// Title label
        simpleTitleLayout()
    }
    
    // MARK: - Utilities
    class func calculatedHeight(session: Session)-> CGFloat {
        return (session.endTime ?? Date()).timeIntervalSinceNow > 0 ? 66 : 0
    }
}

