//
//  SessionDetailsPriceCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/3/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class SessionDetailsPriceCell: UICollectionViewCell, DividerCellProtocol, DectiptionColorCollectionCellprotocol, SimpleTitleCellProtocol, SessionDetailsCellProtocol {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Set text
            text = "Expected payment"
            
            /// Description text
            descriptionText = session.feeString
            
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
        return session.fee > 0 ? 66 : 0
    }
}
