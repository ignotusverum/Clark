//
//  HelpNavigationProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover

protocol HelpNavigationProtocol {
    
    /// Help copy
    var helpCopy: String? { get }
    
    /// Popover setup
    var popover: Popover? { get set }
    
    /// Next Done button
    var nextButton: UIButton? { get set }
    
    /// Help button
    var helpButton: UIButton? { get set }
    
    /// Progress view
    var progressView: UIView { get set }
}

/// Default implementation
extension HelpNavigationProtocol {
    
    /// Next Done button
    var nextButton: UIButton? {
        return nil
    }
    
    /// Help copy
    var helpCopy: String? {
        return nil
    }
    
    /// Popover
    var popover: Popover? {
        return nil
    }
    
    /// Help button
    var helpButton: UIButton? {
        return nil
    }
    
    /// Option setup
    var popoverOptions: [PopoverOption]  {
        return [ .type(.up) ]   
    }
    
    /// Done button
    var doneButton: UIButton? {
        return nil
    }
}

extension HelpNavigationProtocol where Self: UIViewController {
    
    /// Generate progress
    func generateProgressView()-> UIView {

        let view = UIView()
        view.backgroundColor = UIColor.trinidad
        
        view.heroID = "progressView"
        view.heroModifiers = [.cascade()]
        
        return view
    }
    
    /// Layout progress view
    func layoutProgressView(step: Int, total: Int) {
        
        let width = CGFloat(step) * view.bounds.width / CGFloat(total)
        
        view.addSubview(progressView)
        progressView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.height.equalTo(2)
            maker.width.equalTo(width)
        }
    }
    
    /// Generate help button
    func generateHelpButton()-> UIButton {
        
        let button = UIButton(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setBackgroundColor(UIColor.white, forState: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Help", attributes: [NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 19), NSForegroundColorAttributeName: UIColor.trinidad]), for: .normal)
        
        return button
    }
    
    /// Help button layout
    func helpLayout() {
        
        guard let helpButton = helpButton else {
            return
        }
        
        /// Add help button
        view.addSubview(helpButton)
        
        /// Help button layout
        helpButton.snp.updateConstraints { maker in
            maker.bottom.equalTo(self.view).offset(-24)
            maker.left.equalTo(self.view).offset(24)
            maker.width.equalTo(90)
            maker.height.equalTo(50)
        }
        
        /// Help button
        helpButton.layer.borderWidth = 1.5
        helpButton.layer.cornerRadius = 4
        helpButton.layer.borderColor = UIColor.trinidad.cgColor
    }
    
    func nextLayout() {
        
        guard let nextButton = nextButton else {
            return
        }
        
        /// Add next button
        view.addSubview(nextButton)
        
        /// Next button layout
        nextButton.snp.updateConstraints { maker in
            maker.bottom.equalTo(self.view).offset(-24)
            maker.right.equalTo(self.view).offset(-24)
            maker.width.equalTo(110)
            maker.height.equalTo(50)
        }
        
        /// Next button
        nextButton.clipsToBounds = true
        nextButton.layer.cornerRadius = 4
    }
    
    /// Generate next button
    func generateNextButton()-> UIButton {
        
        let button = UIButton()
        button.setBackgroundColor(UIColor.trinidad, forState: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Next", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 19)]), for: .normal)
        button.setImage(#imageLiteral(resourceName: "forward-icon"), for: .normal)
        button.tintColor = UIColor.white
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -120)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        
        return button
    }
    
    /// Generate skip button
    func generateSkipButton()-> UIButton {
        
        let button = UIButton()
        button.setBackgroundColor(UIColor.trinidad, forState: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Skip", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 19)]), for: .normal)
        button.setImage(#imageLiteral(resourceName: "forward-icon"), for: .normal)
        button.tintColor = UIColor.white
        
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -120)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        
        return button
    }
    
    /// Generate done button
    func generateDoneButton()-> UIButton {
        
        let button = UIButton()
        button.setBackgroundColor(UIColor.trinidad, forState: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Done", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 19)]), for: .normal)
        
        return button
    }
    
    /// Generate popover view
    func generatePopover()-> Popover {
        
        /// Popover setup
        let popover = Popover(options: popoverOptions)
        popover.popoverColor = UIColor.ColorWith(red: 68, green: 68, blue: 68, alpha: 1)
        popover.blackOverlayColor = UIColor.clear
        
        return popover
    }
    
    /// Show popover view
    func showPopoveView() {
        
        guard let helpButton = helpButton, let helpCopy = helpCopy, let popover = popover else {
            return
        }
        
        let popoverView = PopoverView(copy: helpCopy)
        let height = helpCopy.heightWithConstrainedWidth(view.bounds.width - 80, font: UIFont.defaultFont(size: 16), spacing: 7)
        var width = helpCopy.heightWithConstrainedWidth(height, font: UIFont.defaultFont(size: 15), spacing: 7)
        
        if width >= view.bounds.width - 40  {
            width = view.bounds.width - 80
        }
        
        popoverView.size = CGSize(width: width, height: height + 30)
        popover.show(popoverView, point: CGPoint(x: helpButton.center.x, y: helpButton.center.y + 30))
    }
}
