//
//  View.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/19/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(cornerRadius: CGFloat = 0.0) {
        
        layer.shadowOffset = CGSize(width: 0, height: 0.8)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.3
        clipsToBounds = false
        
        let shadowFrame: CGRect = layer.bounds
        let shadowPath: CGPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: cornerRadius).cgPath
        layer.shadowPath = shadowPath
    }
}

