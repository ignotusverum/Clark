//
//  CardCompletedNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/14/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import SwiftyJSON
import NMessenger
import AsyncDisplayKit

protocol CardCompletedNodeDelegate {
    func cardTapped(type: CardCompletedType?, id: String?)
}

class CardCompletedNode: ContentNode {

    /// Delegate
    var delegate: CardCompletedNodeDelegate?
    
    override func didLoad() {
        super.didLoad()
        
        layer.backgroundColor = UIColor.clear.cgColor
        
        backgroundColor = UIColor.clear
        backgroundBubble?.bubbleColor = UIColor.clear
    }
    
    override func layout() {
        super.layout()
        
        topDivider.frame = CGRect(x: 0, y: 0.5, w: calculatedSize.width, h: 0.5)
        bottomDivider.frame = CGRect(x: 0, y: calculatedSize.height - 0.5, w: calculatedSize.width, h: 0.5)
        accessoryImage.frame = CGRect(x: calculatedSize.width - 48, y: calculatedSize.height / 2 - 4, w: 8, h: 13)
    }
    
    /// Header node
    lazy var headerNode: ASTextNode = {
       
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        
        return node
    }()
    
    /// Top divider
    lazy var topDivider: ASDisplayNode = {
        
        let node = ASDisplayNode()
        node.isLayerBacked = true
        node.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        return node
    }()
    
    /// Bottom divider
    lazy var bottomDivider: ASDisplayNode = {
        
        let node = ASDisplayNode()
        node.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        return node
    }()
    
    /// Sub header node
    lazy var subHeaderNode: ASTextNode = {
        
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        
        return node
    }()
    
    /// Accessory image
    lazy var accessoryImage: ASImageNode = {
       
        let node = ASImageNode()
        node.image = #imageLiteral(resourceName: "forward-icon")
        node.contentMode = .scaleAspectFit
        node.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.trinidad)
        
        return node
    }()
    
    /// Model
    var model: CardsCompleted
    
    /// Initializer for the cell
    ///
    /// - Parameters:
    ///   - carouselItem: carouselItem model
    ///   - bubbleConfiguration: bubble setup
    init(model: CardsCompleted, bubbleConfiguration: BubbleConfigurationProtocol? = nil) {
        
        self.model = model
        
        super.init(bubbleConfiguration: bubbleConfiguration)
        /// Layout setup
        uiSetup()
        
        /// Data setup
        dataSetup()
    }
    
    /// Initializer for the cell
    ///
    /// - Parameters:
    ///   - carouselItem: carouselItem model
    ///   - currentViewController: controller for presentation
    ///   - bubbleConfiguration: bubble setup
    init(model: CardsCompleted, currentViewController: UIViewController, bubbleConfiguration: BubbleConfigurationProtocol? = nil) {
        self.model = model
        super.init(bubbleConfiguration: bubbleConfiguration)
        self.currentViewController = currentViewController
        /// Layout setup
        uiSetup()
        
        /// Data setup
        dataSetup()
    }
    
    /// Data setup
    func dataSetup() {
        
        /// Header setup
        headerNode.attributedText = NSAttributedString(string: model.header ?? "", attributes: [NSFontAttributeName: UIFont.defaultFont(style: .semiBold, size: 18)])
        
        /// Subheader setup
        subHeaderNode.attributedText = NSAttributedString(string: model.subHeader ?? "", attributes: [NSFontAttributeName: UIFont.defaultFont(), NSForegroundColorAttributeName: UIColor.messageIncomingColor])
    }
    
    /// UI setup
    func uiSetup() {
        
        /// Add subnodes
        addSubnode(accessoryImage)
        addSubnode(topDivider)
        addSubnode(bottomDivider)
        addSubnode(headerNode)
        addSubnode(subHeaderNode)
        
        /// Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(sender:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        /// Header layout
        let headerLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 24, left: 48, bottom: 0, right: 40), child: headerNode)
        
        /// Subheader layout
        let subHeaderLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 48, bottom: 24, right: 24), child: subHeaderNode)
        
        /// Stack setup
        let stackInput = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [headerLayout, subHeaderLayout])
        stackInput.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 100)
        
        return stackInput
    }
    
    // MARK: - Actions
    func tapGesture(sender: UITapGestureRecognizer) {
        delegate?.cardTapped(type: model.type, id: model.id)
    }
}
