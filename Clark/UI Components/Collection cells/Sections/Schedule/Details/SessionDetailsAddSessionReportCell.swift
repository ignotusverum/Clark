//
//  AddSessionReportCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/4/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class SessionDetailsAddSessionReportCell: UICollectionViewCell, DividerCellProtocol, SimpleTitleCellProtocol, AccessoryCellProtocol, SessionDetailsCellProtocol {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Set text
            text = "Create session report"
            
            /// Update layout
            layoutSubviews()
        }
    }
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Accessory image
    lazy var accessoryImageView: UIImageView = self.generateAccessoryImage()
    
    /// Text
    var text: String! {
        didSet {
            /// Title setup
            simpleTitleLabel.text = text
        }
    }
    
    /// Text color setup
    var textColor: UIColor {
        return UIColor.trinidad
    }
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider layout
        dividerLayout()
        
        /// Accessory layout
        accessoryLayout()
        
        /// Title layout
        simpleTitleLayout()
    }
    
    /// Calculated height
    class func calculatedHeight(session: Session) -> CGFloat {
        return session.hasSessionFeedbackReport || (session.endTime ?? Date()).timeIntervalSinceNow > 0 ? 0 : 66
    }
}
