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
import Segment_Branch

enum Screens: String {
    
    case s0 = "Splash"
    case s1 = "Initial chat"
    case s2 = "Video"
    case s3 = "Home"
    case s4 = "Schedule index"
    case s5 = "Clients index"
    case s6 = "Account"
    
    case s7 = "Schedule details"
    case s8 = "Clients details"
    
    case s9 = "Profile details"
    case s10 = "Settings details"
    case s11 = "Terms & Privacy"
    case s12 = "Contact Us"
    
    case s13 = "Create student - name"
    case s14 = "Create student - contact"
    case s15 = "Create student - proxy"
    case s16 = "Subjects"
    case s17 = "Create student - rate"
    
    case s18 = "Create session - student"
    case s19 = "Create session - rate"
    case s20 = "Create session - note"
    case s21 = "Create session - level up"
    
    case s22 = ""
    case s23 = "Create learning plan - cancellation"
    case s24 = "Create learning plan - rate"
    case s25 = "Create learning plan - progress"
    case s26 = "Create learning plan - goals"
    case s27 = "Create learning plan - expectations"
    case s28 = "Create learning plan - send"
    
    case s29 = "Create session report - rate"
    case s30 = "Create session report - progress"
    case s31 = "Create session report - what went well"
    case s32 = "Create session report - improvement"
    case s33 = "Create session report - tast next time"
}

enum Events: String {
    
    case s0_0, s0_1
    case s1_0, s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7
    case s3_0, s3_1, s3_2, s3_3, s3_4, s3_5, s3_6, s3_7, s3_8, s3_9, s3_10, s3_11
    case s4_0, s4_1, s4_2
    case s5_0, s5_1, s5_2
    case s6_0, s6_1, s6_2
    case s7_0, s7_1
    case s8_0, s8_1, s8_2, s8_3
    case s9_0, s9_1
    case s10_0, s10_1
    
    var stringValue: String {
        switch self {
        case .s0_0: return "Meet clark"
        case .s0_1: return "Get started"
            
        case .s1_0: return "Link pressed"
        case .s1_1: return "Text copied"
        case .s1_2: return "Message sent"
        case .s1_3: return "Quick reply pressed"
        case .s1_4: return "Quck action pressed"
        case .s1_5: return "Form submitted"
        case .s1_6: return "Carousel pressed"
        case .s1_7: return "Carousel scrolled"
            
        case .s3_0: return "Onboarding list"
        case .s3_1: return "Link pressed"
        case .s3_2: return "Text copied"
        case .s3_3: return "Message sent"
        case .s3_4: return "Quick reply pressed"
        case .s3_5: return "Quck action pressed"
        case .s3_6: return "Form submitted"
        case .s3_7: return "Action sheet"
        case .s3_8: return "Action sheet presented"
        case .s3_9: return "Carousel pressed"
        case .s3_10: return "Carousel scrolled"
        case .s3_11: return "Image pressed"
            
        case .s4_0: return "Schedule add pressed"
        case .s4_1: return "Schedule search"
        case .s4_2: return "Schedule selected"
        
        case .s5_0: return "Clients add pressed"
        case .s5_1: return "Clients search"
        case .s5_2: return "Client selected"
            
        case .s6_0: return "Edit account pressed"
        case .s6_1: return "Account cell pressed"
        case .s6_2: return "Signout"
            
        case .s7_0: return "Create session report"
        case .s7_1: return "Schedule Details cell pressed"
        
        case .s8_0: return "Client details section selected"
        case .s8_1: return "Client details session selected"
        case .s8_2: return "Create learning plan selected"
        case .s8_3: return "Client details cell selected"
            
        case .s9_0: return "Account details cell pressed"
        case .s9_1: return "Account details save pressed"
            
        case .s10_0: return "Notification setting changed"
        case .s10_1: return "Back button pressed"
        }
    }
}

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
        
        // Setup production key
        STPPaymentConfiguration.shared().publishableKey = StripeKey
        
        // Check version
        VersionManager.checkMinVersionAndShowBlockingUI()
        
        /// Facebook
        let facebook = SEGFacebookAppEventsIntegration.init()
        facebook.applicationDidBecomeActive()
        
        /// Analytics
        ACTAutomatedUsageTracker.enableAutomatedUsageReporting(withConversionID: "863763936")
        ACTConversionReporter.report(withConversionID: "863763936", label: "e6AqCK7gjHIQ4PvvmwM", value: "0.00", isRepeatable: false)
        
        // Setup production key
        STPPaymentConfiguration.shared().publishableKey = StripeKey
        
        ACTAutomatedUsageTracker.enableAutomatedUsageReporting(withConversionID: "863763936")
        ACTConversionReporter.report(withConversionID: "863763936", label: "e6AqCK7gjHIQ4PvvmwM", value: "0.00", isRepeatable: false)
        
        let config = SEGAnalyticsConfiguration(writeKey: SegmentKey)
        
        config.trackApplicationLifecycleEvents = true
        config.recordScreenViews = false
        
        let appsFlyer = SEGAppsFlyerIntegrationFactory()
        config.use(appsFlyer)
        
        let branchSegment = BNCBranchIntegrationFactory()
        config.use(branchSegment)
        
        config.enableAdvertisingTracking = true
        config.trackDeepLinks = true
        config.trackPushNotifications = true
        config.trackAttributionData = true
        
        SEGAnalytics.setup(with: config)
        
        let currentConfig = Config.shared
        if let tutor = currentConfig.currentTutor {
            identify(tutor: tutor)
        }
        
        Fabric.with([Crashlytics.self])
    }
    
    class func identify(tutor : Tutor) {
        
        var traits = [String : Any]()
        traits["Name"] = tutor.fullName
        
        if let _ = tutor.email {  traits["Email"] = tutor.email  }
        if let _ = tutor.phone { traits["Phone"] = tutor.phone }
        if let _ = tutor.subjectsTaught { traits["Subjects Taught"] = tutor.subjectsTaught }
        
        traits["Push Notifications Enabled"] = tutor.pushNotificationsEnabled
        traits["Default Hourly Rate In Cents"] = tutor.defaultHourlyRateInCents
        
        let newId = tutor.id
        SEGAnalytics.shared().identify(newId, traits: traits)
    }
    
    class func screen(screenId: Screens){
        SEGAnalytics.shared().screen(screenId.rawValue)
    }
    
    class func event(name: String, properties: [String : Any]? = nil){
        if (properties != nil) {
            SEGAnalytics.shared().track(name, properties: properties)
        }
        else {
            SEGAnalytics.shared().track(name)
        }
    }
    
    class func trackEventWithID(_ event: Events, eventParams: [String: Any] = [String: Any]()) {
        
        let CTA = event.stringValue
        var screenName: String?
        
        var resultEventParameters = eventParams
        
        switch event {
        case .s0_0, .s0_1:
            screenName = Screens.s0.rawValue
        case .s1_0, .s1_1, .s1_2, .s1_3, .s1_4, .s1_5, .s1_6, .s1_7:
            screenName = Screens.s1.rawValue
        case .s3_0, .s3_1, .s3_2, .s3_3, .s3_4, .s3_5, .s3_6, .s3_7, .s3_8, .s3_9, .s3_10, .s3_11:
            screenName = Screens.s3.rawValue
        case .s4_0, .s4_1, .s4_2:
            screenName = Screens.s4.rawValue
        case .s5_0, .s5_1, .s5_2:
            screenName = Screens.s5.rawValue
        case .s6_0, .s6_1, .s6_2:
            screenName = Screens.s6.rawValue
        case .s7_0, .s7_1:
            screenName = Screens.s7.rawValue
        case .s8_0, .s8_1, .s8_2, .s8_3:
            screenName = Screens.s8.rawValue
        case .s9_0, .s9_1:
            screenName = Screens.s9.rawValue
        case .s10_0, .s10_1:
            screenName = Screens.s10.rawValue
        }
        
        if let screen = screenName {
            resultEventParameters["category"] = screen
        }
        
        SEGAnalytics.shared().track(CTA, properties: resultEventParameters)
    }
    
    func reset() {
        SEGAnalytics.shared().reset()
    }
}
