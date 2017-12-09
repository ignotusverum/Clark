//
//  SuffixInputCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/31/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import IQKeyboardManagerSwift

class SuffixInputCell: UICollectionViewCell, TitleCellProtocol, FormInputCellProtocol, DividerCellProtocol {
    
    /// Delegate
    var delegate: FormInputCellDelegate?
    
    /// Index path
    var indexPath: IndexPath!
    
    /// Suffix text
    var suffixText: String! {
        didSet {
            
            /// Prefix setup
            suffixLabel.text = suffixText
        }
    }
    
    /// Suffix label
    lazy var suffixLabel: UITextField = {
        
        let textField = UITextField()
        textField.isUserInteractionEnabled = false
        textField.font = UIFont.defaultFont(size: 18)
        
        return textField
    }()
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Placeholder
    var placeholder: String! {
        didSet {
            
            formInput.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 18)])
        }
    }
    
    /// Form input
    lazy var formInput: UITextView = self.generateFormInput()
    
    /// Title label
    lazy var titleLabel: UILabel = self.generateTitleLabel()
    
    /// Title text
    var titleText: String! {
        didSet {
            
            /// Title setup
            titleLabel.text = titleText
        }
    }
    
    // MARK: - Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Title layout
        titleLabelLayout()
        
        /// Divider
        dividerLayout()
        
        /// Form input
        addSubview(formInput)
        formInput.delegate = self
        formInput.isScrollEnabled = false
        
        /// Details layout
        formInput.snp.updateConstraints { maker in
            maker.height.equalTo(40)
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self).offset(-24)
            maker.bottom.equalTo(self).offset(-12)
        }
        
        /// suffix setup
        let textCheck: String = formInput.text.length > 0 ? formInput.text : formInput.placeholder
        let textWidth = textCheck.width(usingFont: UIFont.defaultFont(size: 19))
        
        addSubview(suffixLabel)
        
        let bottom: CGFloat = UIScreen.main.nativeBounds.height <= 1334 ? -15 : -13
        suffixLabel.snp.updateConstraints { maker in
            maker.height.equalTo(40)
            maker.left.equalTo(self).offset(20 + textWidth + 10)
            maker.right.equalTo(self).offset(-24)
            maker.bottom.equalTo(self).offset(bottom)
        }
    }
}

extension SuffixInputCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textFieldDidChange(textView, indexPath: indexPath)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            IQKeyboardManager.sharedManager().goNext()
            delegate?.textFieldHitReturn(textView, indexPath: indexPath)
        }
        
        return text != "\n"
    }
}
