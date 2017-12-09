//
//  Avatars.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation
import NMessenger
import AsyncDisplayKit

class Avatars {
    
    /**
     Creates clark avatar with an AsyncDisplaykit *ASImageNode*.
     - returns: ASImageNode
     */
    class func createAvatar()-> ASImageNode {
        
        let avatar = ASImageNode()
        avatar.image = #imageLiteral(resourceName: "clark_avatar")
        avatar.backgroundColor = UIColor.trinidad
        avatar.style.preferredSize = CGSize(width: 36, height: 36)
        avatar.layer.cornerRadius = 18
        
        let config = Config.shared
        let isOpen = config.currentDay?.isCurrentlyOpen ?? false
        
        let isOpenCircle = ASImageNode()
        isOpenCircle.backgroundColor = isOpen ? UIColor.activeStateColor : UIColor.inActiveStateColor
        isOpenCircle.style.preferredSize = CGSize(width: 14, height: 14)
        isOpenCircle.layer.cornerRadius = 7
        
        isOpenCircle.borderWidth = 2
        isOpenCircle.borderColor = UIColor.white.cgColor
        
        isOpenCircle.frame = CGRect(x: 36 - 14, y: 36 - 14, w: 15, h: 15)
        
        avatar.addSubnode(isOpenCircle)
        
        return avatar
    }
    
    /// Creates empty avatar
    ///
    /// - Returns: avatar node
    class func createEmptyAvatar()-> ASImageNode {
        
        let avatar = ASImageNode()
        avatar.backgroundColor = UIColor.clear
        avatar.style.preferredSize = CGSize(width: 1, height: 1)
        
        return avatar
    }
}


