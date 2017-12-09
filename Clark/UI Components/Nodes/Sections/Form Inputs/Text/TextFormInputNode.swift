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

protocol TextFormInputNodeDelegate {
    
    /// Called when should switch to next node
    func nextButtonPressed(_ node: TextFormInputNode)
    
    /// Editing started
    func editingStarted(_ node: TextFormInputNode)
    
    /// Editing ended
    func editingEnded(_ node: TextFormInputNode)
    
    /// Called when done pressed
    func doneButtonPressed(_ node: TextFormInputNode)
}

class TextFormInputNode: ASCellNode {
    
    var textFieldNode: ASTextFieldNode!
    
    /// Cell separator logic
    var shouldShowSeparator: Bool
    
    /// Model
    var formInput: FormTextInput
    
    /// Is submitted state
    var isSubmitted: Bool {
        didSet {
            
            if isSubmitted {
                /// Disable input
                textFieldNode.textField.isUserInteractionEnabled = false
                
                textFieldNode.textField.attributedText = NSAttributedString(string: formInput.value, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 17), NSForegroundColorAttributeName: UIColor.white])
                
                separatorNode.backgroundColor = UIColor.white
            }
        }
    }
    
    /// Delegate
    var delegate: TextFormInputNodeDelegate?
    
    var separatorNode = ASDisplayNode()
    
    override func layout() {
        super.layout()
        
        separatorNode.frame = CGRect(x: 0, y: calculatedSize.height - 0.5, w: calculatedSize.width, h: 1)
    }
    
    init(with formInput: FormTextInput, shouldShowSeparator: Bool, isSubmitted: Bool) {
        
        /// Assign model
        self.formInput = formInput
        
        self.shouldShowSeparator = shouldShowSeparator
        
        /// Is submitted
        self.isSubmitted = isSubmitted
        
        super.init()
        
        /// Text field node init
        textFieldNode = ASTextFieldNode()
        
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
            separatorNode.backgroundColor = UIColor.trinidad.withAlphaComponent(0.5)
            
            textFieldNode.returnKeyType = .next
            
            addSubnode(separatorNode)
        }
        else {
            
            /// Sghow done only for last cell
            textFieldNode.returnKeyType = .done
        }
        
        /// Is submitted check
        if isSubmitted {
            
            /// Disable input
            textFieldNode.textField.isUserInteractionEnabled = false
            
            textFieldNode.textField.attributedText = NSAttributedString(string: formInput.value, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 17), NSForegroundColorAttributeName: UIColor.white])
            
            separatorNode.backgroundColor = UIColor.white
        }
        else {
            
            if formInput.value.length > 0 {
                
                textFieldNode.textField.attributedText = NSAttributedString(string: formInput.value, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 17), NSForegroundColorAttributeName: UIColor.trinidad])
            }
            
            /// Placeholder
            textFieldNode.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 17), NSForegroundColorAttributeName: UIColor.trinidad.withAlphaComponent(0.6)])
        }
    }
    
    /// Layout logic
    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let formInputSize = ASAbsoluteLayoutSpec()
        
        formInputSize.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 40)
        formInputSize.sizing = .sizeToFit
        formInputSize.children = [textFieldNode]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0), child: formInputSize)
    }
}

extension TextFormInputNode: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        textField.layoutIfNeeded()
        
        /// Pass when done button pressed
        if !shouldShowSeparator {
            delegate?.doneButtonPressed(self)
        }
        else {
            delegate?.nextButtonPressed(self)
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.editingStarted(self)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        delegate?.editingEnded(self)
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        
        if string == "\n" {
            return false
        }
        
        return true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        /// Update model value
        formInput.value = textField.text ?? ""
    }
}
