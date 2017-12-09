//
//  RouteHandler.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import PromiseKit
import Foundation

class RouteHandler {
    
    // Shared handler
    static let sharedHandler = RouteHandler()
    
    // MARK: - Initialization
    class func registerDeepLinkHanderWithUrl(_ deepLinkURL: String) { }
    
    // Root controller transition
    class func transitionToController(_ viewController: UIViewController, completed: @escaping () -> Void = {}) {
        
        let appDelegate = AppDelegate.shared
        UIView.transition(with: appDelegate.window!, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
            
            let oldState = UIView.areAnimationsEnabled
            
            UIView.setAnimationsEnabled(false)
            
            appDelegate.window!.rootViewController = viewController
            appDelegate.window!.makeKeyAndVisible()
            
            UIView.setAnimationsEnabled(oldState)
            
        }) { finished in
            
            completed()
        }
    }
    
    // MARK: - Transition logic
    class func presentNavViewController(_ viewController: UIViewController?) {
        
        guard let viewController = viewController else {
            return
        }
        
        transitionToController(viewController)
    }
    
    class func presentViewController(_ viewController: UIViewController?) {
        
        guard let viewController = viewController else {
            return
        }
        
        let appDelegate = AppDelegate.shared
        appDelegate.window?.rootViewController?.presentVC(viewController)
    }
}

