//
//  OnboardingRouteHandler.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

class OnboardingRouteHandler {
    
    /// Initial transition
    class func initialTransition(completed: @escaping ([UIViewController])-> Void = {_ in }) {
        
        /// Create login controller
        let loginVC = InitialViewController()
        
        /// Navigation controller
        let navigationVC = UINavigationController(rootViewController: loginVC)
        
        /// Hide navigation bar
        navigationVC.setNavigationBarHidden(true, animated: false)
        
        /// Handle transition
        RouteHandler.transitionToController(navigationVC) {
            completed([loginVC])
        }
    }
}
