//
//  ExtendedStudentDetailsNavigationBar.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class ExtendedStudentDetailsNavigationBar: UIView, ExtendedNavBarProtocol {
    
    /// Navigation title
    var title: String = ""
    
    /// Appearance style
    var style: ExtendedNavigationStyle
    
    /// Presentation
    var presentation: ExtendedNavigationPresentation {
        didSet {
            
            backButton.setImage(presentation.buttonImage(), for: .normal)
            backButton.imageView?.tintColor = style.contentColor()
            
            /// Background
            backgroundColor = style.backgroudColor()
        }
    }
    
    /// Type
    var type: ExtendedNavigationType
    
    /// Student
    var student: Student
    
    /// Student avatar
    lazy var initialsLabel: UILabel = {
        
        /// Label setup
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.trinidad
        label.backgroundColor = UIColor.white
        label.font = UIFont.defaultFont(size: 16)
        
        /// Background color
        label.backgroundColor = UIColor.trinidad
        label.textColor = UIColor.white
        
        return label
    }()
    
    /// Closure for detecting back button tapped
    private var backButtonTapped: (()->())?
    
    /// Closure for detecting when tab tapped
    fileprivate var tabSelected: ((TopNavigationDatasourceType)->())?
    
    /// Tab switcher view
    lazy var tabSwitcherView: TopNavigationView = {
        
        /// Tab switcher view
        let tabSwitcherView = TopNavigationView(student: self.student)
        tabSwitcherView.backgroundColor = UIColor.lightTrinidad
        
        return tabSwitcherView
    }()
    
    /// Label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    /// Back button
    lazy var backButton: UIButton = {
        
        let button = UIButton(frame: .zero)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -36, bottom: 0, right: 0)
        
        return button
    }()
    
    init(style: ExtendedNavigationStyle, presentation: ExtendedNavigationPresentation = .none, type: ExtendedNavigationType = .studentDetails, student: Student) {
        
        self.type = type
        self.style = style
        self.student = student
        self.presentation = presentation
        
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
        
        /// Background
        backgroundColor = style.backgroudColor()
        
        /// Initials
        addSubview(initialsLabel)
        
        /// Layout - Initials label
        initialsLabel.snp.updateConstraints { maker in
            maker.left.equalTo(16)
            maker.top.equalTo(70)
            maker.width.equalTo(36)
            maker.height.equalTo(36)
        }
        
        /// Layout - Label
        titleLabel.snp.makeConstraints { maker-> Void in
            maker.left.equalTo(self).offset(36 + 16 + 16)
            maker.right.equalTo(self).offset(-22 - initialsLabel.right)
            maker.top.equalTo(70)
            maker.height.equalTo(36)
        }
        
        /// Layout - Back button
        backButton.snp.makeConstraints { maker-> Void in
            maker.left.equalTo(15)
            maker.top.equalTo(15)
            maker.height.equalTo(50)
            maker.width.equalTo(50)
        }

        /// Back button tap
        backButton.addTapGesture(action: { (gesture) in
            
            self.backButtonTapped?()
        })
        
        /// Add tab switcher components
        addSubview(tabSwitcherView)
        tabSwitcherView.delegate = self
        
        tabSwitcherView.snp.updateConstraints { maker in
            maker.left.equalTo(0)
            maker.bottom.equalTo(0)
            maker.height.equalTo(50)
            maker.width.equalTo(self)
        }
        
        /// Rounding
        initialsLabel.clipsToBounds = true
        initialsLabel.layer.borderWidth = 1
        initialsLabel.layer.cornerRadius = 18
        initialsLabel.layer.borderColor = UIColor.white.cgColor
        
        /// Student update
        studentSetup()
    }
    
    fileprivate func studentSetup() {
        
        /// Initials
        initialsLabel.text = student.initials
        
        /// Full name label
        title = student.fullName ?? ""
        titleLabel.attributedText = placeholder()
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
    
    func onTab(_ completion: ((TopNavigationDatasourceType)->())?) {
        tabSelected = completion
    }
    
    /// Switch to tab
    func switchToTab(_ tab: TopNavigationDatasourceType) {
        tabSwitcherView.selectedType = tab
        tabSwitcherView.updateSelection()
    }
}

extension ExtendedStudentDetailsNavigationBar: TopNavigationViewDelegate {
    func onTab(_ selectedType: TopNavigationDatasourceType) {
        tabSelected?(selectedType)
    }
}

