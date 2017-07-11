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
        
        separatorInset = .zero
        
        textField.style.preferredSize = CGSize(width: self.calculatedSize.width, height: 40)
        
        textField.backgroundColor = UIColor.yellow
        /// Form input setup
        /// Placeholder
        textField.attributedPlaceholderText = NSAttributedString(string: formInput.displayName, attributes: [NSFontAttributeName: UIFont.AvenirNextRegular(size: 17), NSForegroundColorAttributeName: UIColor.trinidad])
        
        textField.maximumLinesToDisplay = 1
        textField.textView.font = UIFont.AvenirNextRegular(size: 17)
        textField.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        
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

        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: textInputSize)
    }
}

extension TextFormInputNode: ASEditableTextNodeDelegate {
    
}
