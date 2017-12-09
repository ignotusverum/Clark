//
//  BannerManager.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/13/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import ReachabilitySwift
import EZSwiftExtensions

enum ErrorCategory:Int {
    case stripe
    case form
    case twilio
    case loginSignUp
    case kickoff
    case all
}

class BannerManager: NSObject {  // Set to nsobject to use #selector
    
    // SINGLETONS
    public static let manager = BannerManager()
    private let sharedNotification = ChatViewBanner()
    
    // Publicly set variables
    public var viewController:UIViewController! {
        didSet {
            showCurrentBannerIfNeeded()  // This will be called once the manager is set up. This is here and not in the init file to make sure viewController isn't nil when starting to call banner methods
        }
    }
    public var errorMessageHiddenForCategory:((ErrorCategory)->Void)?  // Callback that returns whatever ErrorCategory was just hidden
    
    // Private variables
    private let reachability = Reachability()
    private var validErrors:[ErrorCategory:Set<String>] = [ErrorCategory:Set<String>]()
    private var didDismissOfflineAlert:Bool?  // false when showing alert, true when offline but alert is dismissed, nil when not offline
    
    // MARK: - Public methods to trigger show/hide and configuration
    
    public func dismissBanner(for errorCategories:[ErrorCategory]) {
        for errorCategory in errorCategories {
            switch errorCategory {
            case .all:
                validErrors.removeAll()
            case .form, .kickoff, .loginSignUp, .stripe, .twilio:
                validErrors[errorCategory] = []
            }
        }
        showCurrentBannerIfNeeded()
    }
    
    // Call only when you want to hide the error message regardless of what it's showing (usually only when chat VC is moving offscreen)
    public func hideCurrentBanner() {
        self.sharedNotification.hide(triggerCallback: false)
    }
    
    public func showBannerForErrorText(_ error:String, category:ErrorCategory) {
        updateBannerForType(type: .error(error), category: category)
    }
    
    public func showBannerForReachability() {
        didDismissOfflineAlert = nil
        updateBannerForType(type: .userDisconnected)
    }
    
    public func showBannerForClarkbot() {
        updateBannerForType(type: .clarkOffline)
    }
    
    public func showCurrentBannerIfNeeded() {
        // Need to run through all possible banner options from highest priority to lowest.
        // Priority order from top to bottom: errors, offline, clarkbot asleep
        
        // First check if any errors exist
        var validError:String?
        var validCategory:ErrorCategory?
        // Loop through all error categories and see if any error exists in any of them
        for key in validErrors.keys {
            if let valid = validErrors[key]?.first {
                validError = valid
                validCategory = key
                break
            }
        }
        if let validError = validError, let validCategory = validCategory {
            showBannerForErrorText(validError, category: validCategory)
        } else if let reachable = reachability?.isReachable, !reachable, (didDismissOfflineAlert == nil || didDismissOfflineAlert == false) {
            // Check if the user has already dismissed the offlineAlert
            updateBannerForType(type: .userDisconnected)
        } else if !(Config.shared.currentDay?.isCurrentlyOpen ?? true) {
            updateBannerForType(type: .clarkOffline)
        } else if sharedNotification.isShowing {
            sharedNotification.hide(triggerCallback: false)
        }
    }
    
    // MARK: - Private methods
    
    // MARK: Init
    
    override init() {
        super.init()
        // Add observers for clarkbot alseep hours and reachability
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: ReachabilityChangedNotification, object: nil)
        ChatViewBanner.hideCallback = {[weak self] (bannerType) in
            self?.handleHide(bannerType: bannerType)
        }
    }
    
    // MARK: Main functions
    
    // Call this function, not the function on the shared notification itself
    private func showBanner(inNavigationController nav:UINavigationController, withType type: BannerType) {
        guard type != sharedNotification.type else { return }  // If the type is the same, don't trigger anything, the correct banner is already being shown.
        
        if sharedNotification.isShowing {
            // If a banner is already being shown, dismiss it and show the new one.
            sharedNotification.hide(triggerCallback:false, completion: { [weak self] in
                guard self != nil else { return }
                self?.sharedNotification.showBanner(inNavigationController: nav, withType: type)
            })
        } else {
            self.sharedNotification.showBanner(inNavigationController: nav, withType: type)
        }
    }
    
    private func updateBannerForType(type:BannerType, category:ErrorCategory? = nil) {
        
        guard let nav = viewController.navigationController, viewController.isViewLoaded, viewController.view.window != nil else { return }  // Make sure we have a valid view controller that's onscreen
        
        var shouldShow = false
        switch type {
        case .clarkOffline:
            switch sharedNotification.type {
            case .error(_)?, .userDisconnected?:
            return // Don't override the current banner
            case .clarkOffline?, nil:
                // Override the current banner
                print("hours issue")
            }
        case .userDisconnected:
            switch sharedNotification.type {
            case .error(_)?:
            return // Don't override the current banner
            case .clarkOffline?, .userDisconnected?, nil:
                // Override the current banner
                if let reachable = self.reachability?.isReachable, !reachable {
                    shouldShow = true
                }
            }
        case .error(let err):
            switch sharedNotification.type {
            case .error(_)?, .clarkOffline?, .userDisconnected?, nil:
                // Override the current banner in all scenarios
                shouldShow = true
                if let category = category {
                    if let _ = self.validErrors[category] {
                        self.validErrors[category]?.insert(err)
                    } else {
                        self.validErrors[category] = Set([err])
                    }
                }
            }
        }
        
        if shouldShow {
            showBanner(inNavigationController: nav, withType: type)
        }
        
        ez.runThisAfterDelay(seconds: 3) {
            self.hideCurrentBanner()
        }
    }
    
    
    // MARK: Callbacks and notifications
    
    private func handleHide(bannerType:BannerType?) {
        switch bannerType {
        case .error(let err)?:
            // Find the error and remove it from the dictionary
            for key in validErrors.keys {
                var strings = validErrors[key]!
                if strings.contains(err) {
                    errorMessageHiddenForCategory?(key)  // This is the cateogory associated with the banner being hidden. Send back the callback.
                    strings.remove(err)
                    validErrors[key] = strings
                    break
                }
            }
        case .userDisconnected?:
            didDismissOfflineAlert = true
        case .clarkOffline?, nil:
            // For now there's no way for clarkOffline to dismiss manually, will only dismiss when showCurrentBannerIfNeeded is called and senses clarkbot is awake. In that case this callback isn't triggered. These cases should never be called.
            print("Banner hiding error")
            break
        }
        showCurrentBannerIfNeeded()
    }
    
    // Track clark hours and update banner when needed
    func didRecieveClarkHoursNotification(_ notification : Notification) {
        showBannerForClarkbot()
    }
    
    // Track reachability and update banner when needed
    func reachabilityChanged(_ notification: NSNotification) {
        showBannerForReachability()
    }
}
