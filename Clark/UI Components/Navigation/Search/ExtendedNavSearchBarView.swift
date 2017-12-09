//
//  ExtendedNavSearchBarView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class ExtendedNavSearchBarView: UIView, ExtendedNavBarProtocol {
    
    /// Navigation title
    var title: String
    
    /// Appearance style
    var style: ExtendedNavigationStyle
    
    /// Presentation
    var presentation: ExtendedNavigationPresentation
    
    /// Type
    var type: ExtendedNavigationType
    
    /// Right action button
    var isRightButtonEnabled: Bool
    
    /// Search textField
    lazy var searchView: SearchView = {
        
        /// Search view
        let searchView = SearchView()
        searchView.backgroundColor = UIColor.lightTrinidad
        
        return searchView
    }()
    
    /// Label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    /// Right action button
    lazy var rightButton: UIButton = {
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus_icon"), for: .normal)
        button.tintColor = UIColor.white
        
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    /// Closure for detecting back button tapped
    private var backButtonTapped: (()->())?
    
    /// Closure for detecting when called textDidChange
    fileprivate var searchTextDidChange: ((String?)->())?
    
    /// Right button pressed
    fileprivate var rightButtonPressed: (()->())?
    
    /// Clear button pressed
    fileprivate var onClearButton: (()->())?
    
    /// Back button
    lazy var backButton: UIButton = {
        
        let button = UIButton(frame: .zero)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -24, bottom: 0, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    init(title: String, style: ExtendedNavigationStyle, presentation: ExtendedNavigationPresentation = .none, type: ExtendedNavigationType = .clean, isRightButtonEnabled: Bool = false) {
        
        self.type = type
        self.title = title
        self.style = style
        self.presentation = presentation
        self.isRightButtonEnabled = isRightButtonEnabled
        
        super.init(frame: CGRect.zero)
        
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom init
    func customInit() {
        
        /// Title Label setup
        addSubview(titleLabel)
        titleLabel.attributedText = placeholder()
        
        /// Back button
        addSubview(backButton)
        
        backButton.setImage(presentation.buttonImage(), for: .normal)
        backButton.imageView?.tintColor = style.contentColor()
        rightButton.imageView?.tintColor = style.contentColor()
        
        rightButton.isHidden = !isRightButtonEnabled
        rightButton.addTarget(self, action: #selector(onRightButton(_:)), for: .touchUpInside)
        
        /// Background
        backgroundColor = style.backgroudColor()
        
        /// Right button
        addSubview(rightButton)
        
        /// Layout - Label
        titleLabel.snp.makeConstraints { maker-> Void in
            maker.left.equalTo(22)
            maker.right.equalTo(-22)
            maker.bottom.equalTo(-5 - 50)
            maker.height.equalTo(50)
        }
        
        /// Layout - Back button
        backButton.snp.makeConstraints { maker-> Void in
            maker.left.equalTo(24)
            maker.top.equalTo(30)
            maker.height.equalTo(50)
            maker.width.equalTo(50)
        }
        
        /// Right action layout
        rightButton.snp.updateConstraints({ maker in
            maker.right.equalTo(-22)
            maker.top.equalTo(30)
            maker.height.equalTo(25)
            maker.width.equalTo(25)
        })
        
        /// Back button tap
        backButton.addTapGesture(action: { (gesture) in
            
            self.backButtonTapped?()
        })
        
        /// Add search components
        if type == .search {
            addSubview(searchView)
            
            searchView.snp.updateConstraints({ maker in
                maker.left.equalTo(0)
                maker.bottom.equalTo(0)
                maker.height.equalTo(50)
                maker.width.equalTo(self)
            })
            
            /// Handle text did chage
            searchView.textDidChange({ text in
                self.searchTextDidChange?(text)
            })
            
            /// Clear button
            searchView.onClearButton({
                self.onClearButton?()
            })
        }
    }
    
    /// Text did change
    func searchDidChange(_ completion: ((String?)->())?) {
        /// Completion handler
        searchTextDidChange = completion
    }
    
    /// Clear button pressed
    func onClearButton(_ completion: (()->())?) {
        onClearButton = completion
    }
    
    /// Right button pressed
    func rightButtonPressed(_ completion: (()->())?) {
        /// Completion handler
        rightButtonPressed = completion
    }
    
    func onRightButton(_ sender: UIButton) {
        rightButtonPressed?()
    }
    
    /**
     *  Called when the view is about to be displayed.  May be called more than
     *  once.
     */
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        // Use the layer shadow to draw a one pixel hairline under this view.
        layer.shadowOffset = CGSize(width: 0, height: CGFloat(1) / UIScreen.main.scale)
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
    }
    
    /// Function to handle closure in parent
    func onBack(_ completion: (()->())?) {
        
        /// Completion handler
        backButtonTapped = completion
    }
}

