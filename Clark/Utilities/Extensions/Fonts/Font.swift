//
//  Font.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import EZSwiftExtensions

extension UIFont {
    
    static func SFProText(_ size: CGFloat = 14)-> UIFont {
        return UIFont(name: "SFProText-Regular", size: fontScalingSize(size))!
    }
    
    static func SFProTextBold(_ size: CGFloat = 14)-> UIFont {
        return UIFont(name: "SFProText-Bold", size: fontScalingSize(size))!
    }
    
    static func SFProTextSemiBold(_ size: CGFloat = 14)-> UIFont {
        return UIFont(name: "SFProText-SemiBold", size: fontScalingSize(size))!
    }
    
    // MARK: - Scaling logic
    class func fontScalingSize(_ size: CGFloat)-> CGFloat {
        
        switch UIDevice().screenType {
        case .iPhone4, .iPhone5:
            return size - 3
        case .iPhone6Plus:
            return size + 3
        default:
            return size
        }
    }
}
