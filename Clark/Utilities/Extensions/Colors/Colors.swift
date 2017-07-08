//
//  Colors.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

extension UIColor {
    
    // MARK: - Default RGB setup
    class func ColorWith(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)-> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    // MARK: - Orange colors
    open class var trinidad: UIColor {
        return ColorWith(red: 234, green: 73, blue: 0, alpha: 1)
    }
    
    open class var trinidadSectionSeparator: UIColor {
        return trinidad.withAlphaComponent(0.66)
    }
    
    // MARK: - Brown colors
    open class var indianKhaki: UIColor {
        return ColorWith(red: 199, green: 166, blue: 141, alpha: 1)
    }
    
    // MARK: - Blue colors
    open class var dodgerBlue: UIColor {
        return ColorWith(red: 51, green: 89, blue: 249, alpha: 1)
    }
    
    open class var dodgerBlueSeparator: UIColor {
        return dodgerBlue.withAlphaComponent(0.33)
    }
    
    open class var dodgerBlueSectionSeparator: UIColor {
        return dodgerBlue.withAlphaComponent(0.66)
    }
    
    open class var portGore: UIColor {
        return ColorWith(red: 38, green: 33, blue: 91, alpha: 1)
    }
    
    open class var robinsEggBlue: UIColor {
        return ColorWith(red: 0, green: 204, blue: 196, alpha: 1)
    }
    
    // MARK: - Grey colors
    open class var shipGray: UIColor {
        return ColorWith(red: 65, green: 64, blue: 66, alpha: 1)
    }
    
    open class var pampas: UIColor {
        return ColorWith(red: 249, green: 248, blue: 245, alpha: 1)
    }
    
    open class var carara: UIColor {
        return ColorWith(red: 235, green: 233, blue: 225, alpha: 1)
    }
    
    open class var messageIncomingColor: UIColor {
        return ColorWith(red: 68, green: 68, blue: 68, alpha: 1)
    }
}
