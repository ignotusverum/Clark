//
//  TextContentNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import NMessenger

extension TextContentNode {
    
    func configure() {
     
        /// Fonts
        incomingTextFont = UIFont.AvenirNextRegular(size: 15)
        outgoingTextFont = UIFont.AvenirNextRegular(size: 15)
        
        /// Colors
        incomingTextColor = UIColor.messageIncomingColor
        outgoingTextColor = UIColor.white
    }
}

