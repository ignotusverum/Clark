//
//  AppDelegate.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Branch
import Analytics
import Locksmith
import PromiseKit
import SVProgressHUD
import KeychainAccess
import TwilioChatClient
import UserNotifications
import IQKeyboardManagerSwift

let AppWakeNotificationKey = "AppWakeNotificationKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    /// Shared
    static let shared = UIApplication.shared.delegate as! AppDelegate
    
    /// Default keychain
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        // get current number of times app has been launched
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        
        // increment received number by one
        UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
        
        // save changes to disk
        UserDefaults.standard.synchronize()
        
        /// Keychain fixes
        checkKeychain()
        
        /// Keyboard manager setup
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldPlayInputClicks = false
        IQKeyboardManager.sharedManager().toolbarTintColor = UIColor.trinidad
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = false
        IQKeyboardManager.sharedManager().disabledToolbarClasses = [HomeViewController.self, InitialViewController.self]
        
        /// Loader setup
        SVProgressHUD.setDefaultMaskType(.clear)
        
        /// Window setup
        AppDelegate.shared.window = UIWindow(frame: UIScreen.main.bounds)
        
        /// Fetching autocomplete
        let _ = ConfigAdapter.config()
        
        /// Analytics tracking
        Analytics.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        /// Fetch Hours data
        fetchHours()
        
        /// Enable shaking
        application.applicationSupportsShakeToEdit = true
        
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
        
        /// Access token
        let apiman = APIManager.shared
        let token = apiman.apiKey
        
        /// Config
        let config = Config.shared
        
        /// Transition to main controller if tutor stored
        if config.currentTutor != nil || token != nil {
            
            TutorAdapter.me().then { response-> Promise<TwilioChatClient?> in
                
                /// Safety check
                if let response = response {
                    config.currentTutor = response
                }
                
                return ConversationManager.conversationStart()
                }.then { _-> Promise<[UIViewController]> in
                    
                    /// Main flow - tab bar
                    return MainRouteHandler.initialTransition()
                }.catch { error in            
                    /// Transition to initial controller
                    let _ = OnboardingRouteHandler.initialTransition()
            }
            
            return
        }
        
        /// Transition to initial controller
        let _ = OnboardingRouteHandler.initialTransition()
    }
    
    /// First install check
    func checkKeychain() {
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            
            /// Token reset
            let apiMan = APIManager.shared
            apiMan.apiKey = nil
            
            /// Legacy reset
            try? Locksmith.deleteDataForUserAccount(userAccount: "UserToken")
            
            /// Tutor reset
            let config = Config.shared
            config.currentTutor = nil
            
            /// Config reset
            Config.userID = nil
            Config.channelID = nil
            Config.twillioToken = nil
            
            // Reset baddges
            UIApplication.shared.applicationIconBadgeNumber = 0
            
            // update the flag indicator
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize() // forces the app to update the NSUserDefaults
            
            return
        }
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        SEGAnalytics.shared().track("Low memory")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Check version
        VersionManager.checkMinVersionAndShowBlockingUI()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        SVProgressHUD.dismiss()
        NotificationCenter.default.post(name: Notification.Name(rawValue: AppWakeNotificationKey), object: nil)
        
        /// Fetch all the pricing info
        let _ = TutorAdapter.me()
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        Branch.getInstance().continue(userActivity)
        AppsFlyerTracker.shared().continue(userActivity, restorationHandler: restorationHandler)
        
        return true
    }
    
    // MARK: - internal URLs Handling
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        
        Branch.getInstance().handleDeepLink(url)
        AppsFlyerTracker.shared().handleOpen(url, options: options)
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) { }
    
    // MARK: - Push Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let conversationMan = ConversationManager.shared
        conversationMan?.updatePushToken(deviceToken: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let conversationMan = ConversationManager.shared
        conversationMan?.updatePushToken(deviceToken: nil)
    }
}

