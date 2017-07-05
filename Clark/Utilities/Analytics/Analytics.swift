//
//  Analytics.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Branch
import Fabric
import Stripe
import Analytics
import Foundation
import Crashlytics
import UserNotifications
import Segment_Facebook_App_Events

class Analytics {
    
    /// Track anatics on launch
    class func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        
        // Get current number of times app has been launched
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        
        // Increment received number by one
        UserDefaults.standard.set(currentCount + 1, forKey:"launchCount")
        
        // Save changes to disk
        UserDefaults.standard.synchronize()
        
        /// Branch setup - deeplink attribution
        let branch = MacroEnviroment == "Prod" ? Branch.getInstance() : Branch.getTestInstance()
        branch?.initSession(launchOptions: launchOptions, andRegisterDeepLinkHandler: { (params, error) in })
        
        /// Facebook tracking
        let facebook = SEGFacebookAppEventsIntegration.init()
        facebook.applicationDidBecomeActive()
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound]) { (granted, error) in }
        
        UIApplication.shared.registerForRemoteNotifications()
        
        // Setup production key
        STPPaymentConfiguration.shared().publishableKey = StripeKey
        
        ACTAutomatedUsageTracker.enableAutomatedUsageReporting(withConversionID: "863763936")
        ACTConversionReporter.report(withConversionID: "863763936", label: "e6AqCK7gjHIQ4PvvmwM", value: "0.00", isRepeatable: false)
        
        Fabric.with([Crashlytics.self])
    }
}
