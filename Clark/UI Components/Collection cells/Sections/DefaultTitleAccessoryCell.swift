//
//  DefaultTitleAccessoryCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/31/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import IQKeyboardManagerSwift

class DefaultTitleAccessoryCell: UICollectionViewCell, TitleCellProtocol, FormInputCellProtocol, DividerCellProtocol, AccessoryCellProtocol {
    
    /// Accessory image
    lazy var accessoryImageView: UIImageView = self.generateAccessoryImage()
    
    /// Delegate
    var delegate: FormInputCellDelegate?
    
    /// Index path
    var indexPath: IndexPath!
    
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
        
        formInput.isUserInteractionEnabled = false
        
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
        
        /// Accessory
        accessoryLayout()
    }
}

extension DefaultTitleAccessoryCell: UITextViewDelegate {
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
