//
//  SearchView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

class SearchView: UIView {

    /// Closure for detecting when called textDidChange
    fileprivate var textDidChange: ((String?)->())?
    
    /// Closure for detecting when close button pressed
    fileprivate var onClearButton: (()->())?
    
    /// Search Icon
    lazy var searchIcon: UIImageView = {
       
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Search")
        imageView.tintColor = UIColor.white
        
        return imageView
    }()
    
    /// Cancel button
    lazy var cancelButton: UIButton = {
       
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "Close"), for: .normal)
        
        button.tintColor = UIColor.lightText
        button.backgroundColor = UIColor.clear
        
        button.addTarget(self, action: #selector(clearButtonPressed(_:)), for: .touchUpInside)
        
        return button
    }()
    
    /// Text field
    lazy var searchTextField: UITextField = {
       
        let textField = UITextField()
        
        textField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.lightText, NSFontAttributeName: UIFont.defaultFont(size: 18)])
        
        textField.font = UIFont.defaultFont(size: 18)
        textField.textColor = UIColor.white
        
        return textField
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Text did change
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        /// Search icon
        addSubview(searchIcon)
        
        /// Cancel Button
        addSubview(cancelButton)
        
        /// Search text field
        addSubview(searchTextField)
        searchTextField.delegate = self
        
        /// Hide cancel initially
        cancelButton.isHidden = true
        
        /// Search layout
        searchIcon.snp.updateConstraints { maker in
            maker.centerY.equalTo(self)
            maker.left.equalTo(self).offset(24)
            maker.height.equalTo(16)
            maker.width.equalTo(16)
        }
        
        /// Cancel layout
        cancelButton.snp.updateConstraints { maker in
            maker.centerY.equalTo(self)
            maker.right.equalTo(self).offset(-27)
            maker.height.equalTo(16)
            maker.width.equalTo(16)
        }
        
        /// Search text field
        searchTextField.snp.updateConstraints { maker in
            maker.left.equalTo(24 + 17 + 10)
            maker.right.equalTo(self).offset(-27 - 16 - 5)
            maker.centerY.equalTo(self).offset(1)
        }
    }
    
    // MARK: - Utilities
    /// Text did change
    func textDidChange(_ completion: ((String?)->())?) {
        /// Completion handler
        textDidChange = completion
    }
    
    func onClearButton(_ completion: (()->())?) {
        /// completion handler
        onClearButton = completion
    }
    
    // MARK: - Actions
    func clearButtonPressed(_ sender: UIButton) {
        onClearButton?()
        searchTextField.text = ""
        cancelButton.isHidden = true
    }
}

extension SearchView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return string != "\n"
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        textDidChange?(textField.text)
        cancelButton.isHidden = (textField.text ?? "").length == 0
    }
}
