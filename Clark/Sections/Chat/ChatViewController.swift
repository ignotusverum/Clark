//
//  ChatViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    /// Status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Left navigation button
    lazy var leftNavigationButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "cal"), style: .plain, target: self, action: #selector(onLeftNavigationButton))
        button.tintColor = UIColor.white
        
        return button
    }()
    
    /// Right navigation button
    lazy var rightNavigationButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(image: #imageLiteral(resourceName: "user_profile"), style: .plain, target: self, action: #selector(onRightNavigationButton))
        button.tintColor = UIColor.white
        
        return button
    }()
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Initial controller setup
        initialSetup()
    }
    
    // MARK: - Initial setup
    func initialSetup() {
     
        /// Background setup
        view.backgroundColor = UIColor.white
        
        /// Logo
        setNavigationImage(#imageLiteral(resourceName: "nav_logo"))
        
        /// Left item
        navigationItem.leftBarButtonItem = leftNavigationButton
        
        /// Right item
        navigationItem.rightBarButtonItem = rightNavigationButton
    }
    
    // MARK: - Actions
    func onLeftNavigationButton() {
        
    }
    
    func onRightNavigationButton() {
        
        /// Safety check
        let config = Config.shared
        guard let tutor = config.currentTutor else {
            return
        }
        
        /// Account flow
        let accountVC = AccountViewController(tutor: tutor)
        pushVC(accountVC)
    }
}
