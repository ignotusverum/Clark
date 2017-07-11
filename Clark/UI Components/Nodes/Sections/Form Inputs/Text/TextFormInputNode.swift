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
    
    /// Cell separator logic
    var shouldShowSeparator: Bool
    
    /// Model
    var formInput: FormTextInput
    
    var separatorNode = ASDisplayNode()
    
    override func layout() {
        super.layout()
        
        separatorNode.frame = CGRect(x: 0, y: calculatedSize.height - 0.5, w: calculatedSize.width, h: 1)
    }
    
    init(with formInput: FormTextInput, shouldShowSeparator: Bool) {
        
        /// Assign model
        self.formInput = formInput
        
        self.shouldShowSeparator = shouldShowSeparator
        
        super.init()
        
        let width = UIScreen.main.bounds.width - 60
        textField.style.preferredSize = CGSize(width: width, height: 49.5)
        /// Form input setup
        /// Placeholder
        textField.attributedPlaceholderText = NSAttributedString(string: formInput.displayName, attributes: [NSFontAttributeName: UIFont.AvenirNextRegular(size: 17), NSForegroundColorAttributeName: UIColor.trinidad])
        
        textField.maximumLinesToDisplay = 1
        textField.textView.font = UIFont.AvenirNextRegular(size: 17)
        textField.textContainerInset = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5)
        
        /// Text color
        textField.tintColor = UIColor.trinidad
        textField.textView.textColor = UIColor.shipGray
        textField.keyboardType = formInput.keyboardType
        textField.autocapitalizationType = formInput.capitalizationType
        
        /// Delegate
        textField.delegate = self
        
        /// Add subnode
        addSubnode(textField)
        
        /// Add separator
        if shouldShowSeparator {
            
            separatorNode.isLayerBacked = true
            separatorNode.style.preferredSize = CGSize(width: width, height: 1)
            separatorNode.backgroundColor = UIColor.trinidad.withAlphaComponent(0.5)
            
            addSubnode(separatorNode)
        }
    }
    
    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let textInputSize = ASStackLayoutSpec.horizontal()

        textInputSize.style.flexShrink = 1
        textInputSize.alignItems = .start
        textInputSize.justifyContent = .start
        textInputSize.verticalAlignment = .top
        textInputSize.children = [textField]

        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), child: textInputSize)
    }
}

extension TextFormInputNode: ASEditableTextNodeDelegate {
    
}
