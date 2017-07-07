//
//  AppDelegate.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// Shared
    static let shared = UIApplication.shared.delegate as! AppDelegate

    /// Default keychain
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        /// Window setup
        AppDelegate.shared.window = UIWindow(frame: UIScreen.main.bounds)
        
        /// Analytics tracking
        Analytics.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        /// Setup initial transition
        transitionSetup()
        
        return true
    }
    
    /// Transition logic
    func transitionSetup() {
        
        /// Transition to main controller if tutor stored
        if let isInitialFinished = Config.isInitialFinished, isInitialFinished {
            
            
            
            /// Chat flow
            ChatRouteHandler.initialTransition()
            
            return
        }
        
        /// Transition to initial controller
        OnboardingRouteHandler.initialTransition()
    }
}
