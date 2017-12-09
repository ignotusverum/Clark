//
//  PopoverView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/25/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class PopoverView: UIView {
    
    /// Copy
    var copyText: String
    
    /// Copy label
    lazy var label: UILabel = {
       
        let label = UILabel()
        
        /// Label setup
        label.numberOfLines = 0
        label.textColor = UIColor.white
        
        return label
    }()
    
    // MARK: - Custom init
    init(copy: String) {
        self.copyText = copy
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("PopoverView not implemented, yo")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Background color
        backgroundColor = UIColor.ColorWith(red: 68, green: 68, blue: 68, alpha: 1)
        
        /// Label
        addSubview(label)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 7
        paragraph.alignment = .left
        label.attributedText = NSAttributedString(string: copyText, attributes: [NSFontAttributeName: UIFont.defaultFont(), NSParagraphStyleAttributeName: paragraph])
        
        /// Label layout
        label.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(10)
            maker.left.equalTo(self).offset(16)
            maker.right.equalTo(self).offset(-10)
            maker.bottom.equalTo(self).offset(-10)
        }
    }
}
