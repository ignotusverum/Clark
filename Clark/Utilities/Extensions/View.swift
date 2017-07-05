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
        
        self.layer.shadowOffset = CGSize(width: 0, height: 0.8)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.3
        self.clipsToBounds = false
        
        let shadowFrame: CGRect = self.layer.bounds
        let shadowPath: CGPath = UIBezierPath(roundedRect: shadowFrame, cornerRadius: cornerRadius).cgPath
        self.layer.shadowPath = shadowPath
    }
}
