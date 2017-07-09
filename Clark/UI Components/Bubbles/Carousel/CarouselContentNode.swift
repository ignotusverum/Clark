//
//  CarouselContentNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import NMessenger
import AsyncDisplayKit

open class CarouselContentNode: ContentNode {

    /// Collection View node
    lazy var collectionViewNode: ASCollectionNode = {
       
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        /// Collection node
        let collectionNode = ASCollectionNode(frame: .zero, collectionViewLayout: layout)
    
        /// Node setup
        collectionNode.backgroundColor = UIColor.clear
        collectionNode.view.showsHorizontalScrollIndicator = false
        
        return collectionNode
    }()
    
    /// Inset for the node
    open var insets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10) {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Initializer for the cell
    ///
    /// - Parameters:
    ///   - carouselItem: carouselItem model
    ///   - bubbleConfiguration: bubble setup
    init(carouselItem: CarouselItem, bubbleConfiguration: BubbleConfigurationProtocol? = nil) {
        
        super.init(bubbleConfiguration: bubbleConfiguration)
        self.setupCarouselNode(carouselItem)
    }
    
    /// Initializer for the cell
    ///
    /// - Parameters:
    ///   - carouselItem: carouselItem model
    ///   - currentViewController: controller for presentation
    ///   - bubbleConfiguration: bubble setup
    init(carouselItem: CarouselItem, currentViewController: UIViewController, bubbleConfiguration: BubbleConfigurationProtocol? = nil)
    {
        super.init(bubbleConfiguration: bubbleConfiguration)
        self.currentViewController = currentViewController
        self.setupCarouselNode(carouselItem)
    }
    
    // MARK: Initializer helper
    /// Create carousel
    ///
    /// - Parameter carouselItem: carousel model
    fileprivate func setupCarouselNode(_ carouselItem: CarouselItem) {
        /// Clear background bubble
        self.backgroundBubble = nil
        
        
    }
}
