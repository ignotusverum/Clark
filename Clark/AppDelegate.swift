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
        
        /// Analytics tracking
        Analytics.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }
    
    /// Transition logic
    func transitionSetup() {
        
        /// Config
        let config = Config.shared
        
        /// Transition to main controller if tutor stored
        if let tutorID = config.currentTutor?.id, tutorID.length > 0 {
            
            return
        }
        
        /// Transition to initial controller
        OnboardingRouteHandler.initialTransition()
    }
}

