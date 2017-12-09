//
//  ViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation
import EZSwiftExtensions

extension UIViewController {
    
    /// Title
    func setTitle(_ titleText: String, subtitle: String = "", color: UIColor = UIColor.black) {
        
        let label = UILabel()
        label.attributedText = titleText.generateTitle(color, subtitle: subtitle)
        label.numberOfLines = 0
        
        label.sizeToFit()
        navigationItem.titleView = label
    }
    
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
    
    /// Custom button
    func setCustomBackButton(image: UIImage, onAction: @escaping (()->())) {
        
        //Back buttion
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(image, for: UIControlState())
        btnLeftMenu.frame = CGRect(x: 0, y: 0, width: 36/2, height: 30/2)
        btnLeftMenu.tintColor = UIColor.trinidad
        btnLeftMenu.adjustsImageWhenHighlighted = false
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        navigationItem.leftBarButtonItem = barButton
        
        btnLeftMenu.addTapGesture { gesture in
            onAction()
        }
    }
}

extension UINavigationController {
    override open var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
}

