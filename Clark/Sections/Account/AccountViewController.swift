//
//  AccountViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Hero
import MessageUI
import PromiseKit
import SVProgressHUD
import SafariServices
import ParallaxHeader
import EZSwiftExtensions

enum AccountCellType: String {
    case settings = "Settings"
    case contact = "Contact Us"
    case terms = "Terms & Privacy"
}

class AccountViewController: UIViewController {
    
    /// Tutor model
    var tutor: Tutor
    
    /// Collection datasource
    var datasource: [AccountCellType] = [.settings, .terms, .contact]
    
    /// Status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// Collection View
    var collectionView: UICollectionView = {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        
        /// Cell registration
        collectionView.register(SignOutCollectionViewCell.self, forCellWithReuseIdentifier: "\(SignOutCollectionViewCell.self)")
        collectionView.register(SimpleTextCollectionViewCell.self, forCellWithReuseIdentifier: "\(SimpleTextCollectionViewCell.self)")
        collectionView.register(VersionCollectionViewCell.self, forCellWithReuseIdentifier: "\(VersionCollectionViewCell.self)")
        
        return collectionView
    }()
    
    /// Collection view header view
    lazy var headerView: AccountView = {
        
        let view = AccountView(tutor: self.tutor)
        return view
    }()
    
    // MARK: - Initialization
    init(tutor: Tutor) {
        self.tutor = tutor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Analytics
        Analytics.screen(screenId: .s6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Update
        headerView.tutor = tutor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Initial UI setup
        initialSetup()
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    // MARK: - Initial setup
    func initialSetup() {
        
        /// Navigation setup
        navigationController?.navigationBar.barTintColor = UIColor.dodgerBlue
        
        /// Collection view
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection header setup
        collectionView.parallaxHeader.view = headerView
        collectionView.parallaxHeader.height = 320
        collectionView.parallaxHeader.minimumHeight = 80
        collectionView.parallaxHeader.mode = .centerFill
        
        /// Background color
        view.backgroundColor = UIColor.trinidad
        
        /// Collection View layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view).offset(-22)
            maker.bottom.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
        }
        
        /// Update
        headerView.layoutSubviews()
        
        /// Handle tap gesture
        headerView.addTapGesture { tap in
            
            /// Push next view
            guard let controller = AccountRouteHandler.editTransition(tutor: self.tutor) else {
                return
            }
            
            /// Transition
            self.presentVC(controller)
        }
    }
    
    // MARK: - Utilities
    fileprivate func composeSupportMessage() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            present(mailComposeViewController, animated: true, completion: nil)
        } else {
            AlertHelper.showAlert(title: "Error Composing Mail Message.", controller: self)
        }
    }
    
    private func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["clark@hiclark.com"])
        mailComposerVC.setSubject("Clark App Support")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    fileprivate func presentWebVC(link: String) {
        
        /// Safety check
        guard let link = URL(string: link) else {
            return
        }
        
        /// Present web view
        let controller = SFSafariViewController(url: link)
        presentVC(controller)
    }
}

// MARK: - CollectionView Delegate
extension AccountViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cellType = datasource[indexPath.row]
            
            /// Analytics
            Analytics.trackEventWithID(.s6_1, eventParams: ["type": cellType.rawValue])
            
            switch cellType {
            case .settings:
                
                /// Settings transition
                guard let settingNavigation = AccountRouteHandler.settingTransition() else {
                    return
                }
                
                presentVC(settingNavigation)
                
            case .terms:
                presentWebVC(link: "https://www.hiclark.com/terms")
                
                /// Analytics
                Analytics.screen(screenId: .s11)
                
            case .contact:
                composeSupportMessage()
                /// Analytics
                Analytics.screen(screenId: .s12)
            }
        }
        else if indexPath.section == 1 {
            
            /// Sign out
            SVProgressHUD.show()
            
            /// Reset data and connect to new
            Config.resetDataAndConnect().then { _-> Promise<[UIViewController]> in
                SVProgressHUD.dismiss()
                /// Analytics
                Analytics.trackEventWithID(.s6_2)
                return OnboardingRouteHandler.initialTransition()
                }.catch { error in
                    SVProgressHUD.dismiss()
            }
        }
    }
}

// MARK: - CollectionView Datasource
extension AccountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 || section == 2 ? .zero : UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - CollectionView Datasource
extension AccountViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return section == 0 ? datasource.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SimpleTextCollectionViewCell.self)", for: indexPath) as! SimpleTextCollectionViewCell
            
            let data = datasource[indexPath.row]
            cell.text = data.rawValue
            
            /// Hide last divider
            cell.dividerView.isHidden = indexPath.row == datasource.count - 1
            
            return cell
        }
        else if indexPath.section == 1 {
            
            /// Sign out button
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SignOutCollectionViewCell.self)", for: indexPath) as! SignOutCollectionViewCell
            
            return cell
        }
        
        /// Version cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(VersionCollectionViewCell.self)", for: indexPath)
        
        return cell
    }
}

// MARK: - Delgate methods
extension AccountViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

