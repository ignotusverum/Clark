//
//  FormInputCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/14/17.
//  Copyright © 2017 Clark. All rights reserved.
//

protocol FormInputCellDelegate {
    
    /// Text field did change
    func textFieldDidChange(_ textView: UITextView, indexPath: IndexPath)
    
    /// Return button pressed
    func textFieldHitReturn(_ textVies: UITextView, indexPath: IndexPath)
}

extension FormInputCellDelegate {
    /// Return button pressed
    func textFieldHitReturn(_ textVies: UITextView, indexPath: IndexPath) {}
}

protocol FormInputCellProtocol {
    
    /// Placeholder
    var placeholder: String! { get set }
    
    /// Index path
    var indexPath: IndexPath! { get set }
    
    /// Form input
    var formInput: UITextView { get set }
    
    /// Delegate
    var delegate: FormInputCellDelegate? { get set }
}

extension FormInputCellProtocol where Self: UICollectionViewCell {
    
    /// Generate form input
    func generateFormInput()-> UITextView {
        
        let textView = UITextView(frame: .zero)
        
        textView.returnKeyType = .next
        textView.autocorrectionType = .no
        textView.tintColor = UIColor.trinidad
        textView.font = UIFont.defaultFont(size: 18)
        
        return textView
    }
}
