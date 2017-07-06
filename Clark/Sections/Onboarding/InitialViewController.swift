//
//  InitialViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import SnapKit

class InitialViewController: UIViewController {

    /// Logo image view
    lazy var logoImageView: UIImageView = {
       
        let imageView = UIImageView(frame: .zero)
        imageView.image = #imageLiteral(resourceName: "Clark")
        imageView.contentMode = .center
        
        return imageView
    }()
    
    /// Title label
    lazy var titleLabel: UILabel = {
       
        let label = UILabel(frame: .zero)
        
        /// UI Setup
        label.numberOfLines = 0
        label.textColor = UIColor.carara
        label.font = UIFont.SFProTextSemiBold(17)
        
        return label
    }()
    
    /// Play video button
    lazy var videoButton: UIButton = {
        
        let button = UIButton(frame: .zero)
        
        /// UI Setup
        button.setTitle("Meet Clark", for: .normal)
        button.setBackgroundColor(UIColor.carara, forState: .normal)
        button.titleLabel?.font = UIFont.SFProTextSemiBold(18)
        
        return button
    }()
    
    /// Onboarding button
    lazy var onboardingButton: UIButton = {
       
        let button = UIButton(frame: .zero)
        
        /// UI Setup
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(UIColor.trinidad, for: .normal)
        button.setBackgroundColor(UIColor.white, forState: .normal)
        button.titleLabel?.font = UIFont.SFProTextSemiBold(17)
        
        return button
    }()
    
    // MARK: - Initialization
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Setup UI
        initialSetup()
    }
    
    // MARK: - UI Setup
    func initialSetup() {
        
        /// Background color
        view.backgroundColor = UIColor.trinidad
        
        /// Logo image
        view.addSubview(logoImageView)
        
        /// Title label
        view.addSubview(titleLabel)
        
        /// Video button
        view.addSubview(videoButton)
        videoButton.addTarget(self, action: #selector(onPlayVideo(_:)), for: .touchUpInside)
        
        /// Onboarding button
        view.addSubview(onboardingButton)
        onboardingButton.addTarget(self, action: #selector(onOnboarding(_:)), for: .touchUpInside)
        
        /// Logo image layout
        logoImageView.snp.updateConstraints { maker in
            maker.height.equalTo(140)
            maker.width.equalTo(110)
            maker.top.equalTo(70)
            maker.centerX.equalTo(self.videoButton)
        }
        
        /// Title label layout
        titleLabel.snp.updateConstraints { maker in
            maker.centerY.equalTo(self.videoButton).offset(-15)
            maker.centerX.equalTo(self.view)
            maker.width.equalTo(255)
            maker.height.equalTo(40)
        }
        
        /// Video button layout
        videoButton.snp.updateConstraints { maker in
            maker.top.equalTo(titleLabel.bottom).offset(30)
            maker.width.equalTo(145)
            maker.height.equalTo(35)
            maker.centerX.equalTo(self.view)
        }
        
        /// Onboarding button layout
        onboardingButton.snp.updateConstraints { maker in
            maker.bottom.equalTo(-40)
            maker.left.equalTo(40)
            maker.right.equalTo(-40)
            maker.height.equalTo(44)
        }
    }
    
    // MARK: - Actions
    func onPlayVideo(_ sender: UIButton) {
        
    }
    
    func onOnboarding(_ sender: UIButton) {
        
    }
}
