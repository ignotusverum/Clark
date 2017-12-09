//
//  SessionDetailsStudentCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/4/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class SessionDetailsStudentCell: UICollectionViewCell, DividerCellProtocol, DectiptionColorCollectionCellprotocol, SimpleTitleCellProtocol, SessionDetailsCellProtocol {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Set text
            text = "Student"
            
            /// Description text
            descriptionText = session.student?.fullName
            
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
        
        /// Decsription label
        addSubview(descriptionLabel)
        
        /// Description label layout
        descriptionLabel.snp.updateConstraints { maker in
            maker.right.equalTo(self).offset(-24)
            maker.width.equalTo(200)
            maker.centerY.equalTo(self)
            maker.height.equalTo(self)
        }
    }
    
    // MARK: - Utilities
    class func calculatedHeight(session: Session)-> CGFloat {
        return session.student != nil ? 66 : 0
    }
}

