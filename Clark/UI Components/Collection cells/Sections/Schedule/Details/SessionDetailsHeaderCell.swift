//
//  SessionDetailsHeaderCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/3/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

class SessionDetailsHeaderCell: UICollectionViewCell, DividerCellProtocol, SessionDetailsCellProtocol {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Date label setup
            dateLabel.text = Copy.sessionDate(session: session)
            
            /// Time label setup
            timeLabel.text = Copy.sessionTime(session: session)
            
            /// Status copy
            statusLabel.textColor = SessionStatus.colors[session.status]
            statusLabel.text = session.status.rawValue.uppercasedPrefix(1).replacingOccurrences(of: "_", with: " ")
            
            /// Update layout
            layoutSubviews()
        }
    }
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Date label
    lazy var dateLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.defaultFont(style: .semiBold, size: 30)
        
        return label
    }()
    
    /// Time label
    lazy var timeLabel: UILabel = {
       
        let label = UILabel()
        label.textColor = UIColor.gray.withAlphaComponent(0.44)
        label.font = UIFont.defaultFont(size: 18)
        
        return label
    }()
    
    /// Status label
    lazy var statusLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.defaultFont(size: 18)
        
        return label
    }()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
        
        /// Divider setup
        dividerLayout()
        
        /// Date label
        addSubview(dateLabel)
        
        /// Time label
        addSubview(timeLabel)
        
        /// Status label
        addSubview(statusLabel)
        
        /// Date label setup
        dateLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(22)
            maker.left.equalTo(self).offset(24)
            maker.height.equalTo(42)
            maker.width.equalTo(self)
        }
        
        /// Time label setup
        timeLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(8 + dateLabel.bottom)
            maker.left.equalTo(self).offset(24)
            maker.height.equalTo(18)
            maker.width.equalTo(self)
        }
        
        /// Status label setup
        statusLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(8 + timeLabel.bottom)
            maker.left.equalTo(self).offset(24)
            maker.height.equalTo(25)
            maker.width.equalTo(self)
        }
    }
    
    // MARK: - Utilities
    class func calculatedHeight(session: Session)-> CGFloat {
        return 140
    }
}
