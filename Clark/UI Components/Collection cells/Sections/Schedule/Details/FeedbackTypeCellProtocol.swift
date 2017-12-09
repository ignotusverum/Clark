//
//  FeedbackTypeCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/4/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation

enum FeedbackType {
    case positive
    case negative
}

protocol FeedbackTypeCellProtocol {
    
    /// Color
    var typeColor: UIColor { get }
    
    /// Type
    var type: FeedbackType! { get }
    
    /// Pin view
    var pinView: UIView { get set }
    
    /// Feedback
    var feedbackString: String! { get set }
    
    /// Title label
    var feedbackTitleLabel: UILabel { get set }
}

extension FeedbackTypeCellProtocol {
    
    /// Color
    var typeColor: UIColor {
        return type == .positive ? UIColor.positiveColor : UIColor.negativeColor
    }
}

extension FeedbackTypeCellProtocol where Self: UICollectionViewCell {
    
    /// Generate pin view
    func generatePinView()-> UIView {
        
        let view = UIView()
        view.backgroundColor = typeColor
        
        return view
    }
    
    /// Generate title label
    func generateFeedbackTitleLabel()-> UILabel {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = typeColor
        label.font = UIFont.defaultFont(size: 18)
        
        return label
    }
}
