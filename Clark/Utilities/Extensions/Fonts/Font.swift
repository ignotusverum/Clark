//
//  Font.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import EZSwiftExtensions

enum FontStyle: String {
    case black = "Black"
    case blackItalic
    
    case bold
    case boldItalic
    
    case light
    case lightItalic
    
    case extraLight
    case extraLightItalic
    
    case medium
    case mediumItalic
    
    case regular
    case regularItalic
    
    case semiBold
    case semiBoldItalic
    
    case thin
    case thinItalic
}

extension UIFont {
    
    /// Default font setup
    static func defaultFont(style: FontStyle = .regular, size: CGFloat = 14)-> UIFont {
        return UIFont(name: "Graphik-\(style.rawValue.capitalizedFirst())", size: fontScalingSize(size))!
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

