//
//  UIVisualEffectView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/20/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

extension UIVisualEffectView {
    
    func fadeInEffect(_ style:UIBlurEffectStyle = .light, withDuration duration: TimeInterval = 0.5) {
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
                self.effect = UIBlurEffect(style: style)
            }
            
            animator.startAnimation()
        }else {
            // Fallback on earlier versions
            UIView.animate(withDuration: duration) {
                self.effect = UIBlurEffect(style: style)
            }
        }
    }
    
    func fadeOutEffect(withDuration duration: TimeInterval = 0.5) {
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                self.effect = nil
            }
            
            animator.startAnimation()
            animator.fractionComplete = 1
        }else {
            // Fallback on earlier versions
            UIView.animate(withDuration: duration) {
                self.effect = nil
            }
        }
    }
}
