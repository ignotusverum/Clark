//
//  ClarkLoader.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/20/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import PromiseKit
import EZSwiftExtensions

class ClarkLoader: UIView {
    
    /// Shared
    static let shared = ClarkLoader(frame: .zero)
    
    /// Logo view
    var logoView: BearLogoView = {
       
        let view = BearLogoView()
        
        return view
    }()
    
    /// Background blur view
    lazy var backgroundView: UIVisualEffectView = {
       
        /// Blur effect
        let effect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: effect)
        
        return view
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        /// Using window bounds
        super.init(frame: AppDelegate.shared.window!.bounds)
        loaderSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom setup
    private func loaderSetup() {
     
        becomeFirstResponder()
        
        /// Background blur
        addSubview(backgroundView)
        
        /// Background blur layout
        backgroundView.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
        
        /// Bear logo
        addSubview(logoView)
        logoView.backgroundColor = UIColor.clear
        
        /// Bear logo layout
        logoView.snp.updateConstraints { maker in
            maker.centerY.equalTo(self)
            maker.centerX.equalTo(self)
            maker.width.equalTo(140)
            maker.height.equalTo(140)
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Utilities
    class func present() {
        
        /// Window check
        let appDelegate = AppDelegate.shared
        guard let window = appDelegate.window else {
            print("WARNING: NO WINDOW")
            return
        }
        
        /// Top VC
        guard let topVC = window.rootViewController else {
            print("WARNING: No controller")
            return
        }
        
        shared.alpha = 1
        shared.logoView.alpha = 0
        shared.backgroundView.fadeOutEffect()
        
        /// Add subview
        topVC.view.addSubview(shared)
        
        /// Trigger animations
        let _ = UIView.promise(animateWithDuration: 0.5, delay: 0.2, options: .curveEaseInOut) {
            shared.backgroundView.fadeInEffect()
            }.then { response-> Promise<Bool> in
                return UIView.promise(animateWithDuration: 0.5, delay: 0.2, options: .curveEaseInOut, animations: {
                    shared.logoView.alpha = 1
                })
        }
        
        window.makeKeyAndVisible()
    }
    
    class func dismiss() {
        
        ez.runThisAfterDelay(seconds: 1) {
         
            /// Remove view
            shared.removeFromSuperview()
        }
        
        ez.runThisAfterDelay(seconds: 1.5) { 
            shared.backgroundView.fadeOutEffect()
        }
    }
    
    /// disco mode
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            ClarkLoader.shared.logoView.colorChange()
        }
    }
}
