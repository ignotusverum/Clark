//
//  SimpleTitleCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol SimpleTitleCellProtocol {
    
    /// Text
    var text: String! { get set }
    
    /// Text color
    var textColor: UIColor { get }
    
    /// Title label
    var simpleTitleLabel: UILabel { get set }
}

extension SimpleTitleCellProtocol{
    
    var textColor: UIColor {
        return UIColor.black
    }
}

extension SimpleTitleCellProtocol where Self: UICollectionViewCell {
    
    func generateSimpleTitleLabel()-> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.defaultFont(size: 17)
        
        label.textAlignment = .left
        return label
    }
    
    func simpleTitleLayout() {
        
        /// Title label
        addSubview(simpleTitleLabel)
        simpleTitleLabel.textColor = textColor
        
        /// Title label layout
        simpleTitleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(25)
            maker.right.equalTo(self).offset(-25)
            maker.height.equalTo(self)
            maker.top.equalTo(self)
        }
    }
}
