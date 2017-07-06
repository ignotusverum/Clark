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
    
    /// Back button
    func setBackButton(image: UIImage) {
        
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
}

extension UINavigationController {
    override open var childViewControllerForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}
