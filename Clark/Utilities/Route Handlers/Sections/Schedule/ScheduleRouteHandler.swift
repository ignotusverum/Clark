//
//  ScheduleRouteHandler.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/3/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Hero
import PromiseKit

class ScheduleRouteHandler {
    
    class func scheduleTransition(session: Session)-> Promise<UINavigationController?> {
        
        return scheduleTransition(sessionID: session.id)
    }
    
    class func scheduleTransition(sessionID: String, transitionType: HeroDefaultAnimationType.Direction = .left)-> Promise<UINavigationController?> {
        
        /// Fetch student info
        return SessionAdapter.fetch(sessionID: sessionID).then { response-> UINavigationController? in
            
            /// Safety check
            guard let response = response else {
                return nil
            }
            
            /// Setup settings VC
            let scheduleDetailsVC = ScheduleDetailsViewController(session: response)
            
            /// Setup navigation  controller
            let navigationVC = UINavigationController(rootViewController: scheduleDetailsVC)
            navigationVC.navigationBar.isTranslucent = false
            
            /// Enable hero animation
            navigationVC.isHeroEnabled = true
            navigationVC.heroModalAnimationType = .slide(direction: .left)
            
            /// Return
            return navigationVC
        }
    }
    
    class func createTransition(student: Student?, isBLockSpinner: Bool = false)-> CreateSessionFlow {
        
        /// Setup navigation  controller
        let navigationVC = CreateSessionFlow(student: student, isBlockedSpinner: isBLockSpinner)
        navigationVC.navigationBar.isTranslucent = false
        
        /// Enable hero animation
        navigationVC.isHeroEnabled = true
        navigationVC.heroModalAnimationType = .cover(direction: .up)
        
        /// Return
        return navigationVC
    }
    
    class func createSessionReportTransition(session: Session)-> (UINavigationController, CreateSessionReportFlow) {
        
        /// Setup navigation  controller
        let flowHandler = CreateSessionReportFlow(session: session)
        
        flowHandler.numberOfSteps = 5
        
        let rootVC = flowHandler.progressVC
        
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.navigationBar.isTranslucent = false
        
        /// Enable hero animation
        navigationVC.isHeroEnabled = true
        navigationVC.heroModalAnimationType = .cover(direction: .up)
        
        /// Return
        return (navigationVC, flowHandler)
    }
}
