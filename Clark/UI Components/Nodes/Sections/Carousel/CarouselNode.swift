//
//  CarouselNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Kingfisher
import AsyncDisplayKit

class CarouselNode: ASCellNode {
    
    let imageNode = ASNetworkImageNode()
    
    /// Model
    var item: CarouselItem
    
    /// Total count
    var count: Int
    
    init(with item: CarouselItem, count: Int) {
        
        /// Assign model
        self.item = item
        
        /// Number of object, for scale
        self.count = count
        
        super.init()
        
        guard let imageURL = item.imageURL else {
            
            imageNode.image = #imageLiteral(resourceName: "Fail")
            
            return
        }
        
        /// Image setup
        imageNode.url = imageURL
        imageNode.placeholderFadeDuration = 0.15
        imageNode.contentMode = .scaleAspectFill
        
        /// Corner radius
        imageNode.cornerRadius = 8
        imageNode.clipsToBounds = true
        
        /// Add subnode
        addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        /// Update ratio
        var imageRatio: CGFloat = item.type == .image ? 0.65 : 1
        if count == 1 {
            imageRatio = 1
        }
        
        if imageNode.image != nil {
            imageRatio = (imageNode.image?.size.height)! / (imageNode.image?.size.width)!
        }
        
        let imagePlace = ASRatioLayoutSpec(ratio: imageRatio, child: imageNode)
        
        let stackLayout = ASStackLayoutSpec.horizontal()
        stackLayout.justifyContent = .start
        stackLayout.alignItems = .start
        stackLayout.style.flexShrink = 1.0
        stackLayout.children = [imagePlace]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0), child: stackLayout)
    }
}

