//
//  TextFieldCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class TextFieldCell: UICollectionViewCell, TextFieldCellProtocol, TitleCellProtocol {
    
    /// Index path
    var indexPath: IndexPath!
    
    /// Form input
    lazy var formInput: UITextField = self.generateFormInput()
    
    /// Delegate
    var delegate: TextFieldCellDelegate?
    
    /// Placeholder
    var placeholder: String! {
        didSet {
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 7
            
            formInput.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 18), NSParagraphStyleAttributeName: paragraph])
        }
    }
    
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
        
        /// Form input
        addSubview(formInput)
        formInput.delegate = self
        
        formInput.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        /// Details layout
        formInput.snp.updateConstraints { maker in
            maker.height.equalTo(40)
            maker.left.equalTo(self).offset(20)
            maker.right.equalTo(self).offset(-24)
            maker.bottom.equalTo(self).offset(-12)
        }
    }
}

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldHitReturn(formInput, indexPath: indexPath)
        return true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        delegate?.textFieldDidChange(formInput, indexPath: indexPath)
    }
}
