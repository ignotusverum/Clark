//
//  SearchTitleView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/31/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class SearchTitleView: UIView {
    
    /// Closure for detecting when called textDidChange
    fileprivate var textDidChange: ((String?)->())?
    
    /// Closure for detecting when close button pressed
    fileprivate var onClearButton: (()->())?
    
    /// Title text
    var titleText: String
    
    /// Title label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.defaultFont(style: .semiBold, size: 30)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 8
        
        label.numberOfLines = 0
        label.attributedText = NSAttributedString(string: self.titleText, attributes: [NSParagraphStyleAttributeName: paragraph])
        
        return label
    }()
    
    /// Search view
    lazy var searchView: SearchView = {
        let view = SearchView()
        
        view.backgroundColor = UIColor.white
        
        view.searchIcon.tintColor = UIColor.black
        view.cancelButton.tintColor = UIColor.black
        view.searchTextField.textColor = UIColor.black
        view.searchTextField.tintColor = UIColor.trinidad
        
        return view
    }()
    
    // MARK: - Custom init
    init(titleText: String) {
        self.titleText = titleText
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white
        
        /// Title label
        addSubview(titleLabel)
        
        /// Title layout
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(24)
            maker.left.equalTo(24)
            maker.right.equalTo(self).offset(-24)
            maker.height.equalTo(100)
        }
        
        /// Search view
        addSubview(searchView)
        searchView.snp.updateConstraints { maker in
            maker.bottom.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
            maker.height.equalTo(55)
        }
        
        /// Add search border
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        border.frame = CGRect(x: 0, y: searchView.frame.height - 2, width: size.width, height: 1)
        
        border.borderWidth = width
        searchView.layer.addSublayer(border)
        searchView.layer.masksToBounds = true
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
}
