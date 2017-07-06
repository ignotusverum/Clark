//
//  InitialViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class InitialViewController: UIViewController {

    /// Video path
    private var videoPath: String?
    
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
        label.textAlignment = .center
        label.textColor = UIColor.carara
        label.font = UIFont.SFProTextSemiBold(15)
        
        label.text = "Take your tutoring business\nto new heights"
        
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
    
    func downloadVideo() {
        
        let s3Man = S3Manager.shared
        s3Man.download(key: "Hi_Clark_rf32.mp4").then { response-> Void in
            
            self.videoButton.loadingIndicator(show: false)
            self.videoPath = response
            self.videoButton.isEnabled = true
            self.videoButton.setImage(#imageLiteral(resourceName: "button-arrow"), for: .normal)
            
            }.catch { error in
                print(error)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /// Onboarding Layer
        onboardingButton.clipsToBounds = true
        onboardingButton.layer.cornerRadius = 8
        
        // Video Button
        videoButton.layer.cornerRadius = videoButton.bounds.height / 2.0
        videoButton.layer.borderWidth = 2.0
        videoButton.layer.borderColor = UIColor(hexString: "ECE9E1")!.cgColor
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
            maker.centerY.equalTo(self.view).offset(-15)
            maker.centerX.equalTo(self.view)
            maker.width.equalTo(300)
            maker.height.equalTo(60)
        }
        
        /// Video button layout
        videoButton.snp.updateConstraints { maker in
            maker.top.equalTo(titleLabel).offset(titleLabel.frame.height + 90)
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
    
    // MARK: - Video Player
    func playVideo () {
        
        /// Safety check to see if vides is saved
        guard let videoPath = videoPath else {
            AlertHelper.showAlert(title: "Whoops, please wait untill we get our video in place.", controller: self)
            return
        }
        
        /// Play video
        let movieUrl = URL(fileURLWithPath: videoPath)
        let player = AVPlayer(url: movieUrl)
        let playerController = VideoViewController()
        playerController.player = player
        
        // Set to allow audio to play through speakers
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        }
        catch {
            print("Can't default to speaker ")
        }
        
        // Present the video
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    // MARK: - Actions
    func onPlayVideo(_ sender: UIButton) {
        
    }
    
    func onOnboarding(_ sender: UIButton) {
        
    }
}
