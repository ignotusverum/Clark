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

class ImageCellNode: ASCellNode {
    
    let imageNode = ASNetworkImageNode()
    
    required init(with imageURL: URL?) {
        super.init()
        
        guard let imageURL = imageURL else {
            
            imageNode.image = #imageLiteral(resourceName: "Fail")
            
            return
        }
        
        /// Image setup
        imageNode.url = imageURL
        imageNode.placeholderFadeDuration = 0.15
        imageNode.contentMode = .scaleAspectFill
        
        /// Add subnode
        addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var imageRatio: CGFloat = 0.5
        if imageNode.image != nil {
            imageRatio = (imageNode.image?.size.height)! / (imageNode.image?.size.width)!
        }
        
        let imagePlace = ASRatioLayoutSpec(ratio: imageRatio, child: imageNode)
        
        let stackLayout = ASStackLayoutSpec.horizontal()
        stackLayout.justifyContent = .start
        stackLayout.alignItems = .start
        stackLayout.style.flexShrink = 1.0
        stackLayout.children = [imagePlace]
        
        return  ASInsetLayoutSpec(insets: UIEdgeInsets.zero, child: stackLayout)
    }
}
