
//
//  MainRouteHandler.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/17/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PromiseKit
import TwilioChatClient
import EZSwiftExtensions

class MainRouteHandler {
    
    /// Initial transition
    class func initialTransition(showLoader: Bool = false, showOnboardingFinished: Bool = false)-> Promise<[UIViewController]> {

        /// Promise transition
        return Promise { fulfill, reject in
            
            AutocompleteAdapter.fetch().then { response-> Promise<Tutor?> in
                
                return TutorAdapter.me()
                }.then { response-> Promise<TwilioChatClient?> in
            
                    guard let tutor = response else {
                        let _ = OnboardingRouteHandler.initialTransition()
                        fulfill([])
                        return Promise(value: nil)
                    }
                    
                    /// Current tutor update
                    let config = Config.shared
                    config.currentTutor = tutor
                    
                    return ConversationManager.conversationStart()
                }.then { _-> Void in
                    
                    let config = Config.shared
                    guard let tutor = config.currentTutor else {
                        return
                    }
                    
                    /// Create main controller
                    let mainVC = MainViewController(tutor: tutor)
                    if showLoader {
                        mainVC.showTypingIndicator()
                    }
                    
                    /// Only call this for onboarding
                    if showOnboardingFinished {
                        ez.runThisAfterDelay(seconds: 0.2, after: {
                            let onboardingFinished = OnboardingFinishedViewController()
                            mainVC.presentVC(onboardingFinished)
                        })
                    }
                
                    /// Handle transition
                    RouteHandler.transitionToController(mainVC) {
                        fulfill([mainVC])
                    }
                }.catch { error in
                    reject(error)
                    let _ = OnboardingRouteHandler.initialTransition()
            }
        }
    }
}
