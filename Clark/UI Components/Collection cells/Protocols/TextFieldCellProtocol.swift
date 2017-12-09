//
//  TextFieldCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

protocol TextFieldCellDelegate {
    
    /// Text field did change
    func textFieldDidChange(_ textField: UITextField, indexPath: IndexPath)
    
    /// Return button pressed
    func textFieldHitReturn(_ textField: UITextField, indexPath: IndexPath)
}

extension TextFieldCellDelegate {
    /// Return button pressed
    func textFieldHitReturn(_ textField: UITextField, indexPath: IndexPath) {}
}

protocol TextFieldCellProtocol {
    
    /// Placeholder
    var placeholder: String! { get set }
    
    /// Index path
    var indexPath: IndexPath! { get set }
    
    /// Form input
    var formInput: UITextField { get set }
    
    /// Delegate
    var delegate: TextFieldCellDelegate? { get set }
}

extension TextFieldCellProtocol where Self: UICollectionViewCell {
    
    /// Generate form input
    func generateFormInput()-> UITextField {
        
        let textField = UITextField()
        
        textField.returnKeyType = .next
        textField.autocorrectionType = .no
        textField.tintColor = UIColor.trinidad
        textField.font = UIFont.defaultFont(size: 18)
        
        return textField
    }
}
