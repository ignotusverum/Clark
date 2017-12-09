//
//  TextInputCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol TextInputCellProtocol {
    
    /// Title label
    var titleLabel: UILabel { get set }
    
    /// Text field
    var textField: UITextField { get set }
}

extension TextInputCellProtocol where Self: UICollectionViewCell {
    
    /// Generate title label
    func generateTitleLabel()-> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.defaultFont()
        
        label.textAlignment = .left
        return label
    }
    
    /// Generate form input
    func generateTextInput(placeholder: String)-> UITextField {
        
        let input = UITextField()
        input.textAlignment = .left
        input.font = UIFont.defaultFont(size: 18)
        input.placeholder = placeholder
        
        return input
    }
    
    /// Layout
    func textInputLayout() {
        
        /// Title label
        addSubview(titleLabel)
        
        /// Form input
        addSubview(textField)
        
        /// Title label layout
        titleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(self).offset(24)
            maker.right.equalTo(self).offset(-24)
            maker.top.equalTo(self).offset(26)
            maker.height.equalTo(self).offset(17)
        }
        
        /// Text field layout
        textField.snp.updateConstraints { maker in
            maker.left.equalTo(self).offset(24)
            maker.right.equalTo(self).offset(-24)
            maker.top.equalTo(titleLabel.bottom).offset(11)
            maker.bottom.equalTo(self).offset(-22)
        }
    }
}
