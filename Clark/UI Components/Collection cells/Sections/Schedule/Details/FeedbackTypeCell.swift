//
//  FeedbackTypeCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/4/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

class FeedbackTypeCell: UICollectionViewCell, FeedbackTypeCellProtocol {
    
    /// Type
    var type: FeedbackType! {
        didSet {
            /// layout setup
            layoutSubviews()
        }
    }
    
    /// Pin view
    lazy var pinView: UIView = self.generatePinView()
    
    /// Title label
    lazy var feedbackTitleLabel: UILabel = self.generateFeedbackTitleLabel()
    
    /// Feedback
    var feedbackString: String! {
        didSet {
            
            /// Title setup
            feedbackTitleLabel.text = feedbackString
            
            /// Layout
            layoutSubviews()
        }
    }
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Pin view
        addSubview(pinView)
        
        /// Feedback label
        addSubview(feedbackTitleLabel)
        
        /// Pin setup
        pinView.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.height.equalTo(24)
            maker.width.equalTo(24)
            maker.left.equalTo(self).offset(24)
        }
        
        /// Feedback title setup
        feedbackTitleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.height.equalTo(26)
            maker.width.equalTo(self).offset(-50)
            maker.left.equalTo(self).offset(pinView.right + 16)
        }
        
        /// Rounding
        pinView.layer.cornerRadius = 12
    }
    
    class func calculatedHeight(text: String?)-> CGFloat {
        return (text ?? "").length > 0 ? 30 : 0
    }
}
