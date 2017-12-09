//
//  ClarkHTMLNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/10/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import NMessenger

class ClarkHTMLNode: TextContentNode {
    
    var message: Message?
    
    open override func messageNodeLongPressSelector(_ recognizer: UITapGestureRecognizer) {
        if recognizer.state == UIGestureRecognizerState.began {
            let touchLocation = recognizer.location(in: view)
            if self.textMessageNode.frame.contains(touchLocation) {
                becomeFirstResponder()
                delay(0.1, closure: {
                    let menuController = UIMenuController.shared
                    menuController.menuItems = [UIMenuItem(title: "Open", action: #selector(ClarkHTMLNode.openURL))]
                    menuController.setTargetRect(self.textMessageNode.frame, in: self.view)
                    menuController.setMenuVisible(true, animated:true)
                })
            }
        }
    }
    
    func openURL() {
        if let url = message?.htmlLink  {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
            let params = ["link": url.absoluteString]
            
            /// Analytics
            if let _ = currentViewController as? HomeViewController {
                Analytics.trackEventWithID(.s3_1, eventParams: params)
            }
            else {
                Analytics.trackEventWithID(.s1_0, eventParams: params)
            }
        }
    }
}
