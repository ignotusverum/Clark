//
//  CustomTextFormInputNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Kingfisher
import AsyncDisplayKit

class CustomTextFormInputNode: TextFormInputNode {
    
    override init(with formInput: FormTextInput, shouldShowSeparator: Bool, isSubmitted: Bool) {

        super.init(with: formInput, shouldShowSeparator: shouldShowSeparator, isSubmitted: isSubmitted)

        /// Assign model
        self.formInput = formInput
        
        self.shouldShowSeparator = shouldShowSeparator
        
        /// Is submitted
        self.isSubmitted = isSubmitted
        
        /// Form input placehodler
        let placeholder = formInput.placeholder.length > 0 ? formInput.placeholder : formInput.displayName
        
        let width = UIScreen.main.bounds.width - 60
        textFieldNode.style.preferredSize = CGSize(width: width, height: 49.5)
        
        textFieldNode.font = UIFont.defaultFont(size: 17)
        
        /// Text color
        textFieldNode.tintColor = UIColor.trinidad
        textFieldNode.textColor = UIColor.shipGray
        textFieldNode.keyboardType = formInput.keyboardType
        textFieldNode.autocapitalizationType = formInput.capitalizationType
        
        /// Disable autocorrection
        textFieldNode.autocorrectionType = .no
        
        /// Delegate
        textFieldNode.textField.delegate = self
        
        textFieldNode.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        /// Add subnode
        addSubnode(textFieldNode)
        
        /// Is password field
        if placeholder.lowercased() == "password" {
            textFieldNode.isSecureTextEntry = true
        }
        
        /// Add separator
        if shouldShowSeparator {
            
            /// Add separator to all cells except last one
            separatorNode.isLayerBacked = true
            separatorNode.style.preferredSize = CGSize(width: width, height: 1)
            separatorNode.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            textFieldNode.returnKeyType = .next
            
            addSubnode(separatorNode)
        }
        else {
            
            /// Sghow done only for last cell
            textFieldNode.returnKeyType = .done
        }
        
        textFieldNode.textField.attributedText = NSAttributedString(string: formInput.value, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 17), NSForegroundColorAttributeName: UIColor.black])
        
        /// Is submitted check
        if isSubmitted {
            /// Disable input
            textFieldNode.textField.isUserInteractionEnabled = false
        }
        else {
            
            /// Placeholder
            textFieldNode.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 17), NSForegroundColorAttributeName: UIColor.lightGray.withAlphaComponent(0.6)])
        }
    }
}
