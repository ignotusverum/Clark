//
//  AccessoryCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

protocol AccessoryCellProtocol {
    
    /// Accessory image
    var accessoryImageView: UIImageView { get set }
    
    /// Accessory tint
    var accessoryTintColor: UIColor { get }
}

extension AccessoryCellProtocol {
    
    var accessoryTintColor: UIColor {
        return UIColor.trinidad
    }
}

extension AccessoryCellProtocol where Self: UICollectionViewCell {
    
    /// Accessory image
    func generateAccessoryImage()-> UIImageView {
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "forward-icon"))
        imageView.tintColor = accessoryTintColor
        
        return imageView
    }
    
    /// Setup divider layout
    func accessoryLayout() {
        
        /// Accessory
        addSubview(accessoryImageView)
        
        /// accessory view
        accessoryImageView.snp.updateConstraints { maker in
            maker.right.equalTo(self).offset(-25)
            maker.height.equalTo(13)
            maker.width.equalTo(8)
            maker.centerY.equalTo(self)
        }
    }
}

