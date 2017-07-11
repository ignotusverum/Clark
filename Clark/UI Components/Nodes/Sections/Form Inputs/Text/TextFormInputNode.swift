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
        
        /// Form input setup
        
        /// Placeholder
        textField.attributedPlaceholderText = NSAttributedString(string: formInput.displayName, attributes: [NSFontAttributeName: UIFont.AvenirNextRegular(size: 17), NSForegroundColorAttributeName: UIColor.trinidad])
        
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
        
        let textInputSize = ASAbsoluteLayoutSpec()
        
        textInputSize.sizing = .sizeToFit
        textInputSize.children = [textField]
        
        return ASInsetLayoutSpec(insets: .zero, child: textInputSize)
    }
}

extension TextFormInputNode: ASEditableTextNodeDelegate {
    
}
