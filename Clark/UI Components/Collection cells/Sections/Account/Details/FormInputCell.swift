//
//  FormInputCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/14/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import IQKeyboardManagerSwift

class FormInputCell: UICollectionViewCell, TitleCellProtocol, FormInputCellProtocol, DividerCellProtocol {
    
    /// Delegate
    var delegate: FormInputCellDelegate?
    
    /// Index path
    var indexPath: IndexPath!
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    var isHiddenTitle: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    /// Placeholder
    var placeholder: String! {
        didSet {
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 7
            
            formInput.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 18), NSParagraphStyleAttributeName: paragraph])
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
            
            /// Update layout
            layoutSubviews()
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
        
        let top: CGFloat = isHiddenTitle ? 15 : 54
        
        /// Details layout
        formInput.snp.updateConstraints { maker in
            maker.top.equalTo(top)
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self).offset(-24)
            maker.bottom.equalTo(self).offset(-12)
        }
    }
}

extension FormInputCell: UITextViewDelegate {
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
