//
//  TextFormInputNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/10/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Kingfisher
import AsyncDisplayKit

class TextFormInputNode: ASCellNode {
    
    let textField = ASEditableTextNode()
    
    /// Model
    var formInput: FormTextInput
    
    init(with formInput: FormTextInput) {
        
        /// Assign model
        self.formInput = formInput
        
        super.init()
        
        textField.style.preferredSize = CGSize(width: 300, height: 40)
        
        /// Form input setup
        /// Placeholder
        textField.attributedPlaceholderText = NSAttributedString(string: formInput.displayName, attributes: [NSFontAttributeName: UIFont.AvenirNextRegular(size: 17), NSForegroundColorAttributeName: UIColor.trinidad])
        
        textField.maximumLinesToDisplay = 1
        textField.textView.font = UIFont.AvenirNextRegular(size: 17)
        textField.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        /// Rounding
        textField.cornerRadius = 8
        textField.clipsToBounds = true
        
        /// Border color
        textField.borderWidth = 1
        textField.borderColor = UIColor.trinidad.cgColor
        
        /// Text color
        textField.tintColor = UIColor.trinidad
        textField.textView.textColor = UIColor.shipGray
        textField.keyboardType = formInput.keyboardType
        textField.autocapitalizationType = formInput.capitalizationType
        
        /// Delegate
        textField.delegate = self
        
        /// Add subnode
        addSubnode(textField)
    }
    
    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let textInputSize = ASStackLayoutSpec()
        
        textInputSize.child = textField
        textInputSize.alignItems = .baselineLast
        textInputSize.style.flexShrink = 1.0
        textInputSize.style.flexGrow = 1.0

        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), child: textInputSize)
    }
}

extension TextFormInputNode: ASEditableTextNodeDelegate {
    
}
