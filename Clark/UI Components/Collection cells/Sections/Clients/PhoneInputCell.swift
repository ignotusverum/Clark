//
//  PhoneInputCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/21/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PhoneNumberKit

protocol PhoneInputCellDelegate {
    
    /// Country selection pressed
    func phoneInputCell(_ cell: PhoneInputCell, tapped countryPicker: CountryInput)
    
    /// Phone entered
    func phoneInputCell(_ cell: PhoneInputCell, phoneNumber: String?)
}

class PhoneInputCell: UICollectionViewCell, TitleCellProtocol, DividerCellProtocol {
    
    /// Delegate
    var delegate: PhoneInputCellDelegate?
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Phone number value
    var phoneNumber: String? {
        
        let phoneNumber = textField.text
        if let text = phoneNumber {
            do {
                
                let phoneNumberKit = PhoneNumberKit()
                
                let phone = try phoneNumberKit.parse(text, withRegion: self.countryCode)
                
                let phoneFormatted = phoneNumberKit.format(phone, toType: .e164)
                
                return phoneFormatted
            }
            catch { }
        }
        
        return phoneNumber
    }
    var rawPhoneInput: String?
    
    // MARK: - Country code
    var countryCode = "US"
    
    // MARK: - Country input
    lazy var countryInput: CountryInput = {
       
        let view = CountryInput()
        view.updateStyle(true)
        
        return view
    }()
    
    /// Phone input
    lazy var textField: PhoneNumberTextField = {
       
        let textField = PhoneNumberTextField()
        textField.tintColor = UIColor.trinidad
        
        return textField
    }()
    
    /// Placeholder
    var placeholder: String! {
        didSet {
            
            textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSFontAttributeName: UIFont.defaultFont(size: 18)])
            layoutSubviews()
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
        
        /// Divider layout
        dividerLayout()
        
        /// Phone input
        addSubview(textField)
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        /// Phone input layout
        textField.snp.updateConstraints { maker in
            maker.height.equalTo(50)
            maker.left.equalTo(self).offset(countryInput.frame.width + 24 + 10)
            maker.right.equalTo(self).offset(-countryInput.frame.width - 24 - 10)
            maker.bottom.equalTo(self).offset(-7)
        }
        
        /// Country input
        addSubview(countryInput)
        countryInput.delegate = self
        
        /// Country input layout
        countryInput.snp.updateConstraints { maker in
            maker.left.equalTo(24)
            maker.height.equalTo(31)
            maker.width.equalTo(45)
            maker.bottom.equalTo(self).offset(-28)
        }
    }
    
    /// Form input
    func textFieldDidChange(textField: PhoneNumberTextField) {
        delegate?.phoneInputCell(self, phoneNumber: phoneNumber)
    }
}

extension PhoneInputCell: CountryInputDelegate {
    func countryInputDidHide(_ picker: CountryInput!) {
    }
    
    func countryInputDidShow(_ picker: CountryInput!) {
        delegate?.phoneInputCell(self, tapped: countryInput)
    }
    
    func countryInputSelectionChanged(_ picker: CountryInput!) {
        textField.text = ""
        rawPhoneInput = ""
        textField.defaultRegion = picker.selectedCountryCode
    }
}
