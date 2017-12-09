//
//  CardActionNode.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/15/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import NMessenger
import AsyncDisplayKit
import EZSwiftExtensions

protocol CardActionNodeDelegate {
    func cardTapped(type: CardDestinationType?, id: String?)
}

class CardActionNode: ContentNode {
    
    /// Delegate
    var delegate: CardActionNodeDelegate?
    
    /// Model
    var model: CardAction
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = UIColor.clear
        layer.backgroundColor = UIColor.clear.cgColor
        backgroundBubble?.bubbleColor = UIColor.clear
    }
    
    /// Accessory image
    lazy var accessoryImage: ASImageNode = {
        
        let node = ASImageNode()
        node.image = #imageLiteral(resourceName: "forward-icon")
        node.contentMode = .scaleAspectFit
        node.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.trinidad)
        
        return node
    }()
    
    lazy var titleNode: ASTextNode = {
        
        let node = ASTextNode()
        return node
    }()
    
    lazy var textNode: ASTextNode = {
        
        let node = ASTextNode()
        return node
    }()
    
    lazy var background: ASDisplayNode = {
       
        let node = ASDisplayNode()
        return node
    }()
    
    lazy var background2: ASDisplayNode = {
        
        let node = ASDisplayNode()
        return node
    }()
    
    /// Initializer for the cell
    ///
    /// - Parameters:
    ///   - carouselItem: carouselItem model
    ///   - bubbleConfiguration: bubble setup
    init(model: CardAction, bubbleConfiguration: BubbleConfigurationProtocol? = nil) {
        
        self.model = model
        
        super.init(bubbleConfiguration: bubbleConfiguration)
        /// Layout setup
        uiSetup()
        
        /// Data setup
        dataSetup()
    }
    
    override func layout() {
        super.layout()
        
        background.frame = CGRect(x: 0, y: 0, w: calculatedSize.width, h: 30)
        background2.frame = CGRect(x: 0, y: 10, w: calculatedSize.width, h: 30)
        accessoryImage.frame = CGRect(x: calculatedSize.width - 24, y: bounds.height - textNode.bounds.height - 10, w: 8, h: 13)
    }
    
    /// Initializer for the cell
    ///
    /// - Parameters:
    ///   - carouselItem: carouselItem model
    ///   - currentViewController: controller for presentation
    ///   - bubbleConfiguration: bubble setup
    init(model: CardAction, currentViewController: UIViewController, bubbleConfiguration: BubbleConfigurationProtocol? = nil) {
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
        textNode.attributedText = NSAttributedString(string: model.body ?? "", attributes: [NSFontAttributeName: UIFont.defaultFont(size: 16), NSForegroundColorAttributeName: UIColor.trinidad])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        
        /// title setup
        titleNode.attributedText = NSAttributedString(string: model.title ?? "", attributes: [NSFontAttributeName: UIFont.defaultFont(size: 14), NSForegroundColorAttributeName: UIColor.black, NSParagraphStyleAttributeName : paragraphStyle])
    }
    
    /// UI setup
    func uiSetup() {
        
        borderWidth = 0.5
        borderColor = UIColor.carara.cgColor
        titleNode.backgroundColor = UIColor.carara
        background.backgroundColor = UIColor.carara
        background2.backgroundColor = UIColor.carara
        
        background.cornerRadius = 10
        cornerRadius = 10
        
        /// Attributes setup
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        
        /// Add subnodes
        addSubnode(background)
        addSubnode(background2)
        addSubnode(textNode)
        addSubnode(titleNode)
        addSubnode(accessoryImage)
        
        ez.runThisAfterDelay(seconds: 3, after: {
            self.view.addTapGesture(action: { gesture in
                self.delegate?.cardTapped(type: self.model.destination, id: self.model.id)
            })
        })
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let width = (model.title ?? "").width(usingFont: UIFont.defaultFont(size: 14)) + 44
        
        let buttonInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0), child: textNode)
        let titleLayout = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumY, child: titleNode)
        titleLayout.style.preferredSize = CGSize(width: width, height: 40)
        
        let stackInput = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .center, alignItems: .center, children: [titleLayout, buttonInset])
        
        stackInput.style.preferredSize = CGSize(width: width, height: 80)
        
        return ASInsetLayoutSpec(insets: .zero, child: stackInput)
    }
}
