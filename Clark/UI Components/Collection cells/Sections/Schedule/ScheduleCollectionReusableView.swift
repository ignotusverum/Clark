//
//  ScheduleCollectionReusableView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/27/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class ScheduleCollectionReusableView: UICollectionReusableView {
 
    /// Session
    var session: Session! {
        didSet {
            
            /// Setup
            customInit()
        }
    }
    
    /// Title label
    lazy var titleLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.messageIncomingColor
        label.font = UIFont.defaultFont(size: 17)
        
        return label
    }()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Bacgkrdoun color
        backgroundColor = UIColor.carara
        
        /// Title label
        addSubview(titleLabel)
        
        /// Title label layout
        titleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(16)
            maker.right.equalTo(-16)
            maker.top.equalTo(12)
            maker.bottom.equalTo(-12)
        }
    }
    
    private func customInit() {
        
        /// Check if current year
        let currentYear = Date().year
        let sessionYear = session.startTime?.year ?? 0
        
        if currentYear >= sessionYear {
            /// Show only mo/date
            titleLabel.text = session.headerString
            
            return
        }
        
        /// Show year
        titleLabel.text = session.localStartTime(format: "MMM yyyy")
    }
}
