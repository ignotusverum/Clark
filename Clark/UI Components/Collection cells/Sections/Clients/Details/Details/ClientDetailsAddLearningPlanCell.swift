//
//  ClientDetailsAddLearningPlanCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class ClientDetailsAddLearningPlanCell: UICollectionViewCell, SimpleTitleCellProtocol, AccessoryCellProtocol, DividerCellProtocol {
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Student
    var student: Student! {
        didSet {
            
            /// Set text
            text = "Create learning plan"
            
            /// Update layout
            layoutSubviews()
        }
    }
    
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
        
        /// Accessory layout
        accessoryLayout()
        
        /// Title layout
        simpleTitleLayout()
        
        /// Divider
        dividerLayout()
    }
    
    /// Calculated height
    class func calculatedHeight(student: Student) -> CGFloat {
        return student.learningPlanArray.count > 0 ? 0 : 66
    }
}
