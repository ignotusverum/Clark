//
//  ImageNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Kingfisher
import NMessenger
import AsyncDisplayKit

class ImageNode: ContentNode {
    
    let imageNode = ASNetworkImageNode()
    
    /// Model
    var imageURL: URL?
    
    init(with imageURL: URL?) {
        
        /// Assign model
        self.imageURL = imageURL
        
        super.init()
        
        guard let imageURL = imageURL else {
            
            imageNode.image = #imageLiteral(resourceName: "Fail")
            
            return
        }
        
        /// Image setup
        imageNode.url = imageURL
        imageNode.cornerRadius = 8
        imageNode.clipsToBounds = true
        imageNode.contentMode = .topLeft
        imageNode.contentsScale = 2
        imageNode.placeholderFadeDuration = 0.15
        
        /// Add subnode
        addSubnode(imageNode)
    }
    
    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let carouselMessageSize = ASAbsoluteLayoutSpec()
        
        carouselMessageSize.style.preferredSize = CGSize(width: 320, height: 180)
        carouselMessageSize.children = [imageNode]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), child: carouselMessageSize)
    }
}
