//
//  ChatRouteHandler.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

class ChatRouteHandler {
    
    /// Initial transition
    class func initialTransition(completed: @escaping ([UIViewController])-> Void = {_ in }) {
        
        /// Create login controller
        let loginVC = ChatViewController()
        
        /// Navigation controller
        let navigationVC = UINavigationController(rootViewController: loginVC)
        
        /// Hide navigation bar
        navigationVC.setNavigationBarHidden(false, animated: false)
        navigationVC.navigationBar.isTranslucent = false
        navigationVC.navigationBar.barTintColor = UIColor.trinidad
        
        /// Handle transition
        RouteHandler.transitionToController(navigationVC) {
            completed([loginVC])
        }
    }
}
