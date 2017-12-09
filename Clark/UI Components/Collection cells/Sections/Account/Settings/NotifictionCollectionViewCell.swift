//
//  NotifictionCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

protocol NotificationCollectionViewCellDelegate {
    
    /// Switcher changed
    func switcherChangedTo(value: Bool)
}

class NotificationCollectionViewCell: UICollectionViewCell, DividerCellProtocol, SimpleTitleCellProtocol {
    
    /// Delegate
    var delegate: NotificationCollectionViewCellDelegate?
    
    /// Tutor
    var tutor: Tutor! {
        didSet {
            
            /// Push notification is enabled
            radioButton.isOn = tutor.pushNotificationsEnabled?.boolValue ?? false
        }
    }
    
    /// Title text
    var text: String! {
        didSet {
            /// Set title text
            simpleTitleLabel.text = text
        }
    }
    
    /// Title
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    /// Divider
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Radio button
    var radioButton: UISwitch = {
       
        var radioButton = UISwitch(frame: .zero)
        return radioButton
    }()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider layout
        dividerLayout()
        
        /// Title layout
        simpleTitleLayout()
        
        /// Radio button
        addSubview(radioButton)
        radioButton.addTarget(self, action: #selector(switcherChanged(sender:)), for: .valueChanged)
        
        /// Radio button layout
        radioButton.snp.updateConstraints { maker in
            maker.right.equalTo(self).offset(-25)
            maker.width.equalTo(60)
            maker.height.equalTo(32)
            maker.centerY.equalTo(self)
        }
    }
    
    // MARK: - Actions
    func switcherChanged(sender: UISwitch) {
        
        /// Delegate call
        delegate?.switcherChangedTo(value: sender.isOn)
    }
}
