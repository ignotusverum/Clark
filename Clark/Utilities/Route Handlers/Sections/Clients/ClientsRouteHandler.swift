//
//  ClientsRouteHandler.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//


import Hero
import PromiseKit
import SwiftMessages

class ClientsRouteHandler {
    
    class func clientTransition(student: Student)-> Promise<UINavigationController?> {
        
        /// Fetch student info
        return clientTransition(studentID: student.id)
    }
    
    class func clientTransition(studentID: String, transitionType: HeroDefaultAnimationType.Direction = .left)-> Promise<UINavigationController?> {
    
        /// Fetch student info
        return StudentAdapter.fetch(studentID: studentID).then { response-> UINavigationController? in
        
            /// Safety check
            guard let response = response else {
                return nil
            }
            
            /// Setup client VC
            let clientVC = ClientsInfoViewController(student: response)
            clientVC.isModal = transitionType == .up
            
            /// Setup navigation  controller
            let navigationVC = UINavigationController(rootViewController: clientVC)
            navigationVC.isNavigationBarHidden = true
            
            /// Enable hero animation
            navigationVC.isHeroEnabled = true
            navigationVC.heroModalAnimationType = .slide(direction: transitionType)
            
            /// Return
            return navigationVC
        }
    }
    
    class func createTransition()-> (UINavigationController, CreateStudentFlow) {
        
        /// Setup navigation  controller
        let flowHandler = CreateStudentFlow()
        
        let navigationVC = UINavigationController(rootViewController: flowHandler.nameVC)
        navigationVC.navigationBar.isTranslucent = false
        
        /// Enable hero animation
        navigationVC.isHeroEnabled = true
        navigationVC.heroModalAnimationType = .cover(direction: .up)
        
        /// Return
        return (navigationVC, flowHandler)
    }
    
    class func createLearningPlanTransition(student: Student)-> (UINavigationController, CreateLearningPlanFlow) {
        
        /// Setup navigation  controller
        let flowHandler = CreateLearningPlanFlow(student: student)
        
        /// Check for subjects
        var numberOfSteps = student.subjectsArray.count == 0 ? 5 : 6
        
        /// Check for sessions
        numberOfSteps = student.sessionsArray.count > 0 ? numberOfSteps	: numberOfSteps + 3
        
        flowHandler.numberOfSteps = numberOfSteps
        
        let navigationVC = UINavigationController(rootViewController: flowHandler.subjectsVC)
        navigationVC.navigationBar.isTranslucent = false
        
        /// Enable hero animation
        navigationVC.isHeroEnabled = true
        navigationVC.heroModalAnimationType = .cover(direction: .up)
        
        /// Return
        return (navigationVC, flowHandler)
    }
}
