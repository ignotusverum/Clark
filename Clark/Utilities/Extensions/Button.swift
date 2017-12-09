//
//  Button.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

extension UIButton {
    func loadingIndicator(show: Bool) {
        if show {
            let indicator = UIActivityIndicatorView()
            let buttonHeight = bounds.size.height
            let buttonWidth = bounds.size.width
            indicator.center = CGPoint(x: buttonWidth-20, y: buttonHeight/2)
            addSubview(indicator)
            indicator.startAnimating()
        } else {
            for view in subviews {
                if let indicator = view as? UIActivityIndicatorView {
                    indicator.stopAnimating()
                    indicator.removeFromSuperview()
                }
            }
        }
    }
}
