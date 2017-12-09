//
//  ExtendedNavBarProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/20/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

enum ExtendedNavigationStyle {
    case light
    case dark
    case orange
    
    /// Background view color
    func backgroudColor()-> UIColor {
        switch self {
        case .dark:
            return UIColor.black
        case .orange:
            return UIColor.trinidad
        default:
            return UIColor.white
        }
    }
    
    /// Content color
    func contentColor()-> UIColor {
        switch self {
        case .light:
            return UIColor.black
        default:
            return UIColor.white
        }
    }
}

enum ExtendedNavigationPresentation {
    
    case modal
    case push
    case none
    
    func buttonImage()-> UIImage {
        
        switch self {
        case .modal:
            return #imageLiteral(resourceName: "Close")
        case .push:
            return #imageLiteral(resourceName: "back_icon")
        default:
            return UIImage()
        }
    }
}

enum ExtendedNavigationType {
    case search
    case clean
    case studentDetails
}

protocol ExtendedNavBarProtocol {
    
    /// Navigation title
    var title: String { get set }
    
    /// Appearance style
    var style: ExtendedNavigationStyle { get set }
    
    /// Type
    var type: ExtendedNavigationType { get set }
    
    /// Back button
    var backButton: UIButton { get set }
}

extension ExtendedNavBarProtocol {
    
    /// Generates default placeholder for text field
    func placeholder()-> NSAttributedString? {
        
        /// Placeholder Params
        let params: [String: Any] = [NSForegroundColorAttributeName: style.contentColor(), NSFontAttributeName: UIFont.defaultFont(style: .semiBold, size: 40)]
        
        return NSAttributedString(string: title, attributes: params)
    }
}
