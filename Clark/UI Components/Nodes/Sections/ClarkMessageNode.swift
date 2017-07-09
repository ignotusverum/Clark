//
//  ClarkMessageNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/9/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation

import UIKit
import NMessenger
import AsyncDisplayKit

//MARK: ClarkMessageNode
/**
 Base message class for N Messenger. Extends GeneralMessengerCell. Holds one message
 */
open class ClarkMessageNode: MessageNode {
    
    /// Message model
    var message: Message
    
    /**
     Initialiser for the cell
     */
    public init(content: ContentNode, message: Message) {
        
        self.message = message
        
        super.init(content: content)
    }
    
    /**
     Overriding layoutSpecThatFits to specifiy relatiohsips between elements in the cell
     */
    override open func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        if message.type == .text {
            return super.layoutSpecThatFits(constrainedSize)
        }
        
        var layoutSpecs: ASLayoutSpec!
        
        //location dependent on sender
        let justifyLocation = isIncomingMessage ? ASStackLayoutJustifyContent.start : ASStackLayoutJustifyContent.end
        
        let width = constrainedSize.max.width - self.cellPadding.left - self.cellPadding.right - self.messageOffset - 15
        
        contentNode?.style.maxWidth = ASDimension(unit: .points, value: width)
        contentNode?.style.maxHeight = ASDimension(unit: .points, value: 100000)
        
        contentNode?.style.flexGrow = 1
        
        let contentSizeLayout = ASAbsoluteLayoutSpec()
        contentSizeLayout.sizing = .sizeToFit
        contentSizeLayout.children = [self.contentNode!]
        
        layoutSpecs = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: justifyLocation, alignItems: .end, children: [createSpace(), contentSizeLayout])
        contentSizeLayout.style.flexShrink = 1
        
        if let headerNode = self.headerNode {
            layoutSpecs = ASStackLayoutSpec(direction: .vertical, spacing: self.headerSpacing, justifyContent: .start, alignItems: isIncomingMessage ? .start : .end, children: [headerNode, layoutSpecs])
        }
        
        if let footerNode = self.footerNode {
            layoutSpecs = ASStackLayoutSpec(direction: .vertical, spacing: self.footerSpacing, justifyContent: .start, alignItems: isIncomingMessage ? .start : .end, children: [layoutSpecs, footerNode])
        }
        
        let cellOrientation = isIncomingMessage ? [layoutSpecs!, createSpace()] : [createSpace(), layoutSpecs!]
        let layoutSpecs2 = ASStackLayoutSpec(direction: .horizontal, spacing: self.messageOffset, justifyContent: justifyLocation, alignItems: .end, children: cellOrientation)
        return ASInsetLayoutSpec(insets: self.cellPadding, child: layoutSpecs2)
    }
    
    func createSpace() -> ASLayoutSpec{
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1
        spacer.style.flexShrink = 1
        spacer.style.minHeight = ASDimension(unit: .points, value: 0)
        return spacer
    }
}
