//
//  ViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    
    /// Add navigation image to navigation controller
    ///
    func setNavigationImage(_ image: UIImage) {
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.black
        navigationItem.titleView = imageView
    }
}

extension UINavigationController {
    override open var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
