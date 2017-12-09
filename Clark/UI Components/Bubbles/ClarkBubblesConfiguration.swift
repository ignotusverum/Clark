//
//  ClarkBubblesConfiguration.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation
import NMessenger

open class ClarkBubblesConfiguration: BubbleConfigurationProtocol {
    
    open var isMasked = false

    public init() {}

    open func getIncomingColor() -> UIColor
    {
        return UIColor.carara
    }

    open func getOutgoingColor() -> UIColor
    {
        return UIColor.trinidad
    }

    open func getBubble() -> Bubble
    {
        let newBubble = DefaultBubble()
        newBubble.hasLayerMask = isMasked
        return newBubble
    }

    open func getSecondaryBubble() -> Bubble
    {
        let newBubble = StackedBubble()
        newBubble.hasLayerMask = isMasked
        return newBubble
    }
}
