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
        
        /// Fetch Hours data
        fetchHours()
        
        /// Setup initial transition
        transitionSetup()
        
        return true
    }
    
    /// Hour setup
    private func fetchHours() {
        
        ConfigAdapter.hours().catch { error in
            print(error)
        }
    }
    
    /// Transition logic
    private func transitionSetup() {
        
        /// Status bar
        UIApplication.shared.statusBarStyle = .lightContent
        
        /// Set main screen - launch
        let launchSB = UIStoryboard(name: "LaunchScreen", bundle: nil)
        let launchVC = launchSB.instantiateViewController(withIdentifier: "LaunchScreen")
        
        window?.rootViewController = launchVC
        window?.makeKeyAndVisible()
        
        /// Transition to main controller if tutor stored
        if let isInitialFinished = Config.isInitialFinished, isInitialFinished {
            
            /// Connect to channel
            ConversationManager.conversationStart().then { _-> Void in
                /// Chat flow
                ChatRouteHandler.initialTransition()
                }.catch { error in
                    
                    /// Failed to connect - go to initial flow
                    OnboardingRouteHandler.initialTransition()
            }
            
            return
        }
        
        /// Transition to initial controller
        OnboardingRouteHandler.initialTransition()
    }
}
