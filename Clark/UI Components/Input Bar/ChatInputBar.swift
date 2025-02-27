//
//  ChatInputBar.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import NMessenger

protocol ChatInputBarDelegate {
    
    /// Called when bar text changed
    func inputBar(_ inputBar: ChatInputBar, textChanged: String)
    
    /// Called when send button pressed
    func inputBar(_ inputBar: ChatInputBar, sendText: String)
    
    /// Called when plus sign pressed
    func inputBarAccessoryPressed(_ inputBar: ChatInputBar)
    
    /// Called when keyboard presented for input
    func inputActive(_ inpuBar: ChatInputBar)
}

/// Optional
extension ChatInputBarDelegate {
    func inputBarAccessoryPressed(_ inputBar: ChatInputBar) {}
}

class ChatInputBar: InputBarView, UITextViewDelegate {
    
    /// Delegate
    var delegate: ChatInputBarDelegate?
    
    var shouldEnableLeftAction: Bool = false
    
    var isActionOpened: Bool = false {
        didSet {
            if isActionOpened {
                UIView.animate(withDuration: 0.1, animations: {
                    self.actionButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi/5 + 0.2)
                })
                return
            }
            
            UIView.animate(withDuration: 0.1, animations: {
                self.actionButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            })
        }
    }
    
    /// InputBarView
    @IBOutlet open weak var inputBarView: UIView!
    
    /// Send button
    @IBOutlet open weak var sendButton: UIButton!
    
    //@IBOutlets NSLayoutConstraint input area view height
    @IBOutlet open weak var textInputAreaViewHeight: NSLayoutConstraint!
    
    // NSLayoutConstraint input view height
    @IBOutlet open weak var textInputViewHeight: NSLayoutConstraint!
    
    /// Left inputView
    @IBOutlet open weak var leftActionViewWidth: NSLayoutConstraint!
    
    /// Action button
    @IBOutlet weak var actionButton: UIButton!
    
    //CGFloat to the fine the number of rows a user can type
    open var numberOfRows: CGFloat = 5
    
    var isEnabled: Bool = true {
        didSet {
            
            /// Enable actions
            isUserInteractionEnabled = isEnabled
            
            /// Change UI
            UIView.animate(withDuration: 0.2) {
                self.alpha = self.isEnabled ? 1 : 0.5
            }
        }
    }
    
    //String as placeholder text in input view
    open var inputTextViewPlaceholder: String = "Type a message..." {
        willSet(newVal) {
            self.textInputView.text = newVal
        }
    }
    
    fileprivate let textInputViewHeightConst:CGFloat = 30
    
    // MARK: Initialisers
    public required init() {
        super.init()
    }
    
    init(controller:NMessengerViewController, isEnabled : Bool = true) {
        super.init(controller: controller)
        loadFromBundle(isEnabled)
    }
    
    public required init(controller:NMessengerViewController,frame: CGRect) {
        super.init(controller: controller,frame: frame)
        loadFromBundle()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromBundle()
    }
    
    public required init(controller: NMessengerViewController, enableLeftAction: Bool = false) {
        super.init(controller: controller)
        self.shouldEnableLeftAction = enableLeftAction
        loadFromBundle()
    }
    
    required init(controller: NMessengerViewController) {
        super.init(controller: controller)
        loadFromBundle()
    }
    
    fileprivate func loadFromBundle(_ isEnabled : Bool = true) {
        _ = Bundle.main.loadNibNamed("ChatInputBar", owner: self, options: nil)?[0] as! UIView
        self.addSubview(inputBarView)
        inputBarView.frame = self.bounds
        textInputView.delegate = self
        sendButton.isEnabled = false
        
        if !shouldEnableLeftAction {
            leftActionViewWidth.constant = 0
        }
        
        if (!isEnabled) {
            textInputView.text = ""
            textInputView.isEditable = false
        }
    }
    
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        textView.textColor = .black
        delegate?.inputBar(self, textChanged: "")
        
        UIView.animate(withDuration: 0.1, animations: {
            self.sendButton.isEnabled = true
        })
        
        DispatchQueue.main.async(execute: {
            textView.selectedRange = NSMakeRange(0, 0)
        })
        
        return true
    }
    
    open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if self.textInputView.text.isEmpty {
            self.addInputSelectorPlaceholder()
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            self.sendButton.isEnabled = false
        })
        
        self.textInputView.resignFirstResponder()
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.inputActive(self)
    }
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text == "" && (text != "\n") {
            UIView.animate(withDuration: 0.1, animations: {
                self.sendButton.isEnabled = true
            })
            return true
        }
        else if (text == "\n") && textView.text != "" {
            if textView == self.textInputView {
                textInputViewHeight.constant = textInputViewHeightConst
                textInputAreaViewHeight.constant = textInputViewHeightConst+10
                
                /// Delegate call
                delegate?.inputBar(self, sendText: textInputView.text)
                
                self.textInputView.text = ""
                return false
            }
        }
        else if (text != "\n") {
            
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            
            var textWidth: CGFloat = UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset).width
            
            textWidth -= 2.0 * textView.textContainer.lineFragmentPadding
            
            let boundingRect: CGRect = newText.boundingRect(with: CGSize(width: textWidth, height: 0), options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], attributes: [NSFontAttributeName: textView.font!], context: nil)
            
            let numberOfLines = boundingRect.height / textView.font!.lineHeight
            
            return numberOfLines <= numberOfRows
        }
        
        return false
    }
    /**
     Implementing textViewDidChange in order to resize the text input area
     */
    open func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        textInputViewHeight.constant = newFrame.size.height
        
        textInputAreaViewHeight.constant = newFrame.size.height+10
        
        /// Pass text changed event
        delegate?.inputBar(self, textChanged: textView.text)
    }
    
    //MARK: TextView helper methods
    /**
     Adds placeholder text and change the color of textInputView
     */
    fileprivate func addInputSelectorPlaceholder() {
        self.textInputView.text = self.inputTextViewPlaceholder
        self.textInputView.textColor = UIColor.trinidad.withAlphaComponent(0.4)
    }
    
    //MARK: @IBAction selectors
    /**
     Send button selector
     Sends the text in textInputView to the controller
     */
    @IBAction open func sendButtonClicked(_ sender: AnyObject) {
        textInputViewHeight.constant = textInputViewHeightConst
        textInputAreaViewHeight.constant = textInputViewHeightConst + 10
        if textInputView.text != "" {
            
            delegate?.inputBar(self, sendText: textInputView.text)
            
            textInputView.text = ""
        }
    }
    /**
     Plus button selector
     Requests camera and photo library permission if needed
     Open camera and/or photo library to take/select a photo
     */
    @IBAction open func plusClicked(_ sender: UIButton) {
        delegate?.inputBarAccessoryPressed(self)
        
        isActionOpened = !isActionOpened
    }
    
    func hide(){
        DispatchQueue.main.async {
            self.isHidden = true
            self.inputBarView.isHidden = true
            self.textInputView.isEditable = false
            self.sendButton.isHidden = true
        }
    }
}

