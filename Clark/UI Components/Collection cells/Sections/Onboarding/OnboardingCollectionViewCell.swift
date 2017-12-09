//
//  OnboardingCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/28/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    /// Status
    var onboardingModel: OnboardingFlows!
    var positionNumber: String!
    
    /// Status view
    lazy var statusButton: UIButton = {
        
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = UIFont.defaultFont(style: .bold, size: 20)
        button.setTitleColor(UIColor.black, for: .normal)
        
        return button
    }()
    
    /// Title label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.font = UIFont.defaultFont(style: .bold, size: 17)
        
        return label
    }()
    
    /// Description label
    lazy var descriptionLabel: UILabel = {
        
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.defaultFont()
        
        return label
    }()
    
    // MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Status button
        addSubview(statusButton)
        
        /// If completed - show checkmark
        if onboardingModel.completed {
            
            statusButton.clipsToBounds = true
            statusButton.setTitle("", for: .normal)
            statusButton.setImage(#imageLiteral(resourceName: "onboarding-checkmark-icon"), for: .normal)
            statusButton.setBackgroundColor(UIColor.black, forState: .normal)
            
            /// Title
            let attributeString =  NSMutableAttributedString(string: onboardingModel.headline ?? "")
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            titleLabel.attributedText = attributeString
            
            statusButton.setBackgroundColor(UIColor.trinidad, forState: .normal)
            
            statusButton.layer.borderColor = UIColor.trinidad.cgColor
            statusButton.layer.borderWidth = 2
        }
        else {
            
            statusButton.setTitle(positionNumber, for: .normal)
            statusButton.setImage(UIImage(), for: .normal)
            statusButton.setBackgroundColor(UIColor.white, forState: .normal)
            titleLabel.text = onboardingModel.headline
            
            statusButton.layer.borderColor = UIColor.black.cgColor
            statusButton.layer.borderWidth = 2
        }
        
        /// Title label
        addSubview(titleLabel)
        
        /// Description label
        addSubview(descriptionLabel)
        descriptionLabel.text = onboardingModel.description
        
        /// Status button layout
        statusButton.snp.updateConstraints { maker in
            maker.left.equalTo(16)
            maker.height.equalTo(40)
            maker.width.equalTo(40)
            maker.top.equalTo(16)
        }
        
        /// Title label
        titleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(statusButton).offset(statusButton.frame.height + 10)
            maker.height.equalTo(22)
            maker.right.equalTo(self).offset(-16)
            maker.top.equalTo(statusButton)
        }
        
        /// Description label
        descriptionLabel.snp.updateConstraints { maker in
            maker.left.equalTo(statusButton).offset(statusButton.frame.height + 10)
            maker.right.equalTo(self).offset(-16)
            maker.top.equalTo(titleLabel).offset(titleLabel.frame.height + 4)
        }
        
        descriptionLabel.sizeToFit()
        
        statusButton.clipsToBounds = true
        statusButton.layer.cornerRadius = statusButton.frame.height / 2
    }
    
    /// Cell size calculatin
    class func calculateCellSize(model: OnboardingFlows, width: CGFloat)-> CGSize {
        
        let title = model.headline ?? ""
        let titleHeight = title.heightWithConstrainedWidth(width - 82, font: UIFont.defaultFont(style: .bold, size: 17))
        
        let description = model.description ?? ""
        let descriptionHeight = description.heightWithConstrainedWidth(width - 82, font: UIFont.defaultFont())
        
        return CGSize(width: width, height: titleHeight + descriptionHeight + 16 + 16)
    }
}
