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
import EZSwiftExtensions

protocol FormInputContentNodeDelegate {
    
    /// Called when done button pressed on keyboard
    ///
    /// - Parameters:
    ///   - node: current node
    ///   - formInputs: form inputs
    func formInputsOnDoneButton(node: FormInputContentNode, message: Message)
    
    /// Editing started
    func formInputEditingStarted(_ node: FormInputContentNode)
    
    /// Editing ended
    func formInputEditingEnded(_ node: FormInputContentNode)
}

open class FormInputContentNode: ContentNode {
    
    /// Carousel Items
    var formInputs: FormInputs
    
    /// Message
    var message: Message {
        didSet {
            
            /// Updates
            formInputs = message.formInputs!

            UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseInOut, animations: {
            
                /// Update UI state
                self.setupFormInputNode()
                self.collectionViewNode.reloadData()
                
            }, completion: nil)
        }
    }
    
    /// Delegate
    var delegate: FormInputContentNodeDelegate?
    
    /// Title node
    lazy var titleNode: ASTextNode = {
       
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        
        return node
    }()
    
    /// Submit button node
    lazy var submitButton: ASButtonNode = {
        
        let button = ASButtonNode()
        button.setTitle("Submit", with: UIFont.defaultFont(style: .bold, size: 17), with: UIColor.white, for: .normal)
        button.backgroundColor = UIColor.trinidad
        
        /// Button target
        button.addTarget(self, action:#selector(buttonClicked(sender:)), forControlEvents: .touchUpInside)
        
        return button
        
    }()
    
    /// Subtitle
    lazy var subTitleNode: ASTextNode = {
        
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        
        return node
    }()
    
    /// Collection View node
    lazy var collectionViewNode: ASCollectionNode = {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection node
        let collectionNode = ASCollectionNode(frame: .zero, collectionViewLayout: layout)
        
        collectionNode.view.isScrollEnabled = false
        
        /// Node setup
        collectionNode.view.showsVerticalScrollIndicator = false
        collectionNode.view.showsHorizontalScrollIndicator = false
        
        return collectionNode
    }()
    
    /// Inset for the node
    open var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Initializer for the cell
    ///
    /// - Parameters:
    ///   - formInputs: carouselItem model
    ///   - bubbleConfiguration: bubble setup
    init(message: Message, bubbleConfiguration: BubbleConfigurationProtocol? = nil) {
        
        self.message = message
        self.formInputs = message.formInputs!
        
        super.init(bubbleConfiguration: bubbleConfiguration)
        self.setupFormInputNode()
    }
    
    /// Initializer for the cell
    ///
    /// - Parameters:
    ///   - formInputs: carouselItem model
    ///   - currentViewController: controller for presentation
    ///   - bubbleConfiguration: bubble setup
    init(message: Message, currentViewController: UIViewController, bubbleConfiguration: BubbleConfigurationProtocol? = nil)
    {
        self.message = message
        self.formInputs = message.formInputs!
        
        super.init(bubbleConfiguration: bubbleConfiguration)
        self.currentViewController = currentViewController
        self.setupFormInputNode()
    }
    
    // MARK: Initializer helper
    /// Create carousel
    ///
    /// - Parameter carouselItem: carousel model
    fileprivate func setupFormInputNode() {
        /// Clear background bubble
        layer.backgroundColor = UIColor.clear.cgColor
        
        addSubnode(collectionViewNode)
        
        /// Collection node setup
        collectionViewNode.delegate = self
        collectionViewNode.dataSource = self
        
        backgroundColor = UIColor.clear
        backgroundBubble?.bubbleColor = UIColor.clear
        
        /// Is submitted check
        if (formInputs.state == .submitted || formInputs.state == .submitting) && formInputs.type != .custom {
            collectionViewNode.backgroundColor = UIColor.trinidad
        }
        else if (formInputs.state == .submitted || formInputs.state == .submitting) && formInputs.type == .custom {
            
            alpha = 0.4
            submitButton.alpha = 0.4
            submitButton.isUserInteractionEnabled = false
            collectionViewNode.isUserInteractionEnabled = false
        }
        
        /// Setup title / subtitle
        if formInputs.type == .custom {
            
            titleNode.attributedText = NSAttributedString(string: formInputs.header ?? "", attributes: [NSFontAttributeName: UIFont.defaultFont(style: .bold, size: 20)])
            
            subTitleNode.attributedText = NSAttributedString(string: formInputs.subHeader ?? "", attributes: [NSFontAttributeName: UIFont.defaultFont(size: 16)])
            
            /// Submit button
            submitButton.style.preferredSize = CGSize(width: (currentViewController?.view.bounds.width ?? 0) - 40, height: 44)
            
            submitButton.clipsToBounds = true
            submitButton.layer.cornerRadius = 8
            
            /// Add title/subtitle
            addSubnode(titleNode)
            addSubnode(subTitleNode)
            addSubnode(submitButton)
        }
        else {
            
            /// Rounding
            collectionViewNode.cornerRadius = 8
            collectionViewNode.clipsToBounds = true
            
            /// Border color
            collectionViewNode.borderWidth = 1
            collectionViewNode.borderColor = UIColor.trinidad.cgColor
        }
        
        /// Reload cells
        collectionViewNode.reloadData()
    }
    
    // MARK: - Collection layout
    open override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let formInputSize = ASAbsoluteLayoutSpec()
        
        /// Calculated height
        var calculatedHeight = CGFloat(formInputs.updatedDatasource.count * 50)
        if formInputs.type == .custom {
            calculatedHeight = calculatedHeight + 20
        }
        
        formInputSize.style.preferredSize = CGSize(width: constrainedSize.max.width, height: calculatedHeight)
        formInputSize.sizing = .sizeToFit
        
        formInputSize.children = [collectionViewNode]
        
        if formInputs.type != .custom {
            
            return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), child: formInputSize)
        }
        else {
           
            let titleLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10, left: 25, bottom: 0, right: 15), child: titleNode)
            
            let subtitleLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 25, bottom: 0, right: 15), child: subTitleNode)
            
            let collectionLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 7, left: 8, bottom: 0, right: 30), child: formInputSize)
            
            let submitButtonLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 35, bottom: 0, right: 20), child: submitButton)
            
            let stackInput = ASStackLayoutSpec(direction: .vertical, spacing: 5, justifyContent: .start, alignItems: .start, children: [titleLayout, subtitleLayout, collectionLayout, submitButtonLayout])
            formInputSize.style.preferredSize = CGSize(width: constrainedSize.max.width, height: calculatedHeight)
            
            return stackInput
        }
    }
    
    // MARK: - Utilities
    func buttonClicked(sender: UIButton) {
        delegate?.formInputsOnDoneButton(node: self, message: message)
    }
}

// MARK: - ASCollectionDataSource
extension FormInputContentNode: ASCollectionDataSource {
    
    public func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        
        let isSubmitted = formInputs.state == .submitted || formInputs.state == .submitting
        let formData = formInputs.updatedDatasource[indexPath.row] as? FormTextInput
        
        if self.formInputs.type != .custom && formData != nil {
            
            let shouldShowSeparator = indexPath.row != self.formInputs.updatedDatasource.count - 1
            let formInput = TextFormInputNode(with: formData!, shouldShowSeparator: shouldShowSeparator, isSubmitted: isSubmitted)
            
            /// Done button pressed delegate
            formInput.delegate = self
            
            return formInput
        }
        else if formData != nil {
            
            let shouldShowSeparator = indexPath.row != self.formInputs.updatedDatasource.count - 1
            let formInput = CustomTextFormInputNode(with: formData!, shouldShowSeparator: shouldShowSeparator, isSubmitted: isSubmitted)
            
            /// Done button pressed delegate
            formInput.delegate = self
            
            return formInput
        }
        
        return ASCellNode()
    }
    
    public func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    public func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return formInputs.updatedDatasource.count
    }
    
    public func collectionView(_ collectionView: ASCollectionView, constrainedSizeForNodeAt indexPath: IndexPath) -> ASSizeRange {
        let width = collectionView.size.width - 40

        return ASSizeRange(min: CGSize(width: width, height: 30), max: CGSize(width: width, height: 50))
    }
}

// MARK: - ASCollectionDelegate
extension FormInputContentNode: ASCollectionDelegate {
    public func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

extension FormInputContentNode: TextFormInputNodeDelegate {
    
    /// Editing started
    func editingStarted(_ node: TextFormInputNode) {
        delegate?.formInputEditingStarted(self)
    }
    
    /// Editing ended
    func editingEnded(_ node: TextFormInputNode) {
        delegate?.formInputEditingEnded(self)
    }
    
    /// Done pressed in input form
    func doneButtonPressed(_ node: TextFormInputNode) {
        delegate?.formInputsOnDoneButton(node: self, message: message)
    }
    
    /// Called when should switch to next node
    func nextButtonPressed(_ node: TextFormInputNode){
        
        /// Index of selected node
        let index = formInputs.updatedDatasource.index { $0.displayName == node.formInput.displayName } ?? 0
        
        /// Get next cell
        if let cell = collectionViewNode.nodeForItem(at: IndexPath(item: index + 1, section: 0)) as? TextFormInputNode {
            
            if let previousCell = collectionViewNode.nodeForItem(at: IndexPath(item: index, section: 0)) as? TextFormInputNode {
                previousCell.textFieldNode.textField.resignFirstResponder()
                previousCell.textFieldNode.textField.layoutIfNeeded()
            }
            
            cell.textFieldNode.textField.becomeFirstResponder()
        }
    }
}
