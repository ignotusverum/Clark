//
//  AccountRouteHandler.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import PromiseKit
import Foundation

class AccountRouteHandler {

    class func settingTransition()-> UINavigationController? {
    
        /// Safety check
        let config = Config.shared
        guard let tutor = config.currentTutor else {
            let _ = TutorAdapter.me()
            return nil
        }
        
        /// Setup settings VC
        let settingsVC = SettingsViewController(tutor: tutor)
        
        /// Setup navigation  controller
        let navigationVC = UINavigationController(rootViewController: settingsVC)
        navigationVC.navigationBar.isTranslucent = false
        
        /// Enable hero animation
        navigationVC.isHeroEnabled = true
        navigationVC.heroModalAnimationType = .slide(direction: .left)
        
        /// Return
        return navigationVC
    }
    
    class func editTransition(tutor: Tutor)-> UINavigationController? {
        
        /// Account edit VC
        let editVC = AccountDetailsViewController(tutor: tutor)
        
        /// Setup navigation  controller
        let navigationVC = UINavigationController(rootViewController: editVC)
        navigationVC.navigationBar.isTranslucent = false
        
        /// Enable hero animation
        navigationVC.isHeroEnabled = true
        navigationVC.heroModalAnimationType = .slide(direction: .left)
        
        /// Return
        return navigationVC
    }
}
