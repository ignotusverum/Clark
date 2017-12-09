//
//  SessionDetailsReminders.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/15/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class SessionDetailsReminders: UICollectionViewCell, DividerCellProtocol, DectiptionColorCollectionCellprotocol, SimpleTitleCellProtocol, SessionDetailsCellProtocol {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Set text
            text = "Reminders"
            
            /// Description text
            
            if let reminders = session.isRemindersOn?.boolValue {
                descriptionText = reminders ? "Enabled" : "Disabled"
            }
            
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
    
    /// Description Text
    var descriptionText: String! {
        didSet {
            
            descriptionLabel.text = descriptionText
        }
    }
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    /// Description color
    var descriptionColor: UIColor {
        return UIColor.trinidad
    }
    
    /// Description label
    lazy var descriptionLabel: UILabel = self.generateDescriptionLabel()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider view
        dividerLayout()
        
        /// Title label
        simpleTitleLayout()
        
        /// Description layout
        descriptionLabelLayout()
    }
    
    // MARK: - Utilities
    class func calculatedHeight(session: Session)-> CGFloat {
        return session.isRemindersOn != nil ? 66 : 0
    }
}

