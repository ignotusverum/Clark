//
//  FormInputContentNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/10/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import NMessenger
import AsyncDisplayKit

open class FormInputContentNode: ContentNode {
    
    /// Carousel Items
    var formInputs: FormInputs
    
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
        collectionNode.view.showsHorizontalScrollIndicator = false
        
        collectionNode.backgroundColor = UIColor.green
        
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
    ///   - formInputs: carouselItem model
    ///   - bubbleConfiguration: bubble setup
    init(formInputs: FormInputs, bubbleConfiguration: BubbleConfigurationProtocol? = nil) {
        
        self.formInputs = formInputs
        
        super.init(bubbleConfiguration: bubbleConfiguration)
        self.setupCarouselNode()
    }
    
    /// Initializer for the cell
    ///
    /// - Parameters:
    ///   - formInputs: carouselItem model
    ///   - currentViewController: controller for presentation
    ///   - bubbleConfiguration: bubble setup
    init(formInputs: FormInputs, currentViewController: UIViewController, bubbleConfiguration: BubbleConfigurationProtocol? = nil)
    {
        self.formInputs = formInputs
        super.init(bubbleConfiguration: bubbleConfiguration)
        self.currentViewController = currentViewController
        self.setupCarouselNode()
    }
    
    // MARK: Initializer helper
    /// Create carousel
    ///
    /// - Parameter carouselItem: carousel model
    fileprivate func setupCarouselNode() {
        /// Clear background bubble
        layer.backgroundColor = UIColor.clear.cgColor
        
        addSubnode(collectionViewNode)
        
        /// Collection node setup
        collectionViewNode.delegate = self
        collectionViewNode.dataSource = self
    }
    
    // MARK: - Collection layout
    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let carouselMessageSize = ASAbsoluteLayoutSpec()
        
        carouselMessageSize.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 160)
        carouselMessageSize.sizing = .sizeToFit
        carouselMessageSize.children = [collectionViewNode]
        
        return ASInsetLayoutSpec(insets: insets, child: carouselMessageSize)
    }
}

// MARK: - ASCollectionDataSource
extension FormInputContentNode: ASCollectionDataSource {
    
    public func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        
        let formData = formInputs.datasource[indexPath.row] as! FormTextInput
        let formInput = TextFormInputNode(with: formData)
        
        if indexPath.row == formInputs.datasource.count {
            formInput.textField.returnKeyType = .done
        }
        
        return formInput
    }
    
    public func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return formInputs.datasource.count
    }
}

// MARK: - ASCollectionDelegate
extension FormInputContentNode: ASCollectionDelegate {
    public func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}
