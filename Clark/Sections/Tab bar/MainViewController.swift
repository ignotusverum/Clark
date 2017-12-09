//
//  MainViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/17/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import StoreKit
import TwilioChatClient
import EZSwiftExtensions

enum TabTitles: String, CustomStringConvertible {
    case home
    case schedule
    case clients
    case profile
    
    internal var description: String {
        return rawValue.uppercasedPrefix(0)
    }
    
    static let allValues = [home, schedule, clients, profile]
}

private var tabIcons = [
    TabTitles.home: "home",
    TabTitles.schedule: "schedule",
    TabTitles.clients: "clients",
    TabTitles.profile: "profile"
]

class MainViewController: UITabBarController {
    
    /// Home flow
    lazy var homeVC: HomeViewController = {
        let vc = HomeViewController()
        vc.delegate = self
        
        return vc
    }()
    
    lazy var homeFlow: UINavigationController = {
       
        /// Home VC
        let homeVC = self.homeVC
        let homeNavigation = UINavigationController()
        homeNavigation.navigationBar.barTintColor = UIColor.trinidad
        homeNavigation.navigationBar.isTranslucent = false
        homeNavigation.viewControllers = [homeVC]
        
        return homeNavigation
    }()
    
    /// Schedule flow
    lazy var scheduleFlow: UINavigationController = {
        
        let scheduleVC = ScheduleViewController()
        scheduleVC.delegate = self
        let scheduleNavigation = UINavigationController()
        scheduleNavigation.navigationBar.isHidden = true
        scheduleNavigation.viewControllers = [scheduleVC]
        
        return scheduleNavigation
    }()
    
    /// Clients flow
    lazy var clientsFlow: UINavigationController = {
        
        let clientsVC = ClientsViewController()
        clientsVC.delegate = self
        let clientsNavigation = UINavigationController()
        clientsNavigation.navigationBar.isHidden = true
        clientsNavigation.viewControllers = [clientsVC]
        
        return clientsNavigation
    }()
    
    /// Profile flow
    lazy var accountFlow: UINavigationController = {
        
        let accountVC = AccountViewController(tutor: self.tutor)
        let accountNavigation = UINavigationController()
        accountNavigation.navigationBar.isHidden = true
        accountNavigation.viewControllers = [accountVC]
        
        return accountNavigation
    }()
    
    /// Tab bar controllers
    lazy var controllers: [UIViewController] = {
        
        return [self.homeFlow, self.scheduleFlow, self.clientsFlow, self.accountFlow]
    }()
    
    /// Tutor object
    var tutor: Tutor!
    
    // MARK: - Initialization
    init(tutor: Tutor) {
        self.tutor = tutor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Contoller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Init controllers
        viewControllers = controllers
        
        /// Setup tabbar
        setupTabBar()
        
        // get current number of times app has been launched
        let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
        
        if currentCount > 3 {
            
            /// Add artifitial delay
            ez.runThisAfterDelay(seconds: 15, after: {
                if #available(iOS 10.3, *) {
                    if let view = AppDelegate.shared.window?.rootViewController?.view {
                        view.endEditing(true)
                        SKStoreReviewController.requestReview()
                    }
                }
            })
        }
    }
    
    /// Setup tabBar appearance
    private func setupTabBar() {
        
        /// Make it solid
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.black
        tabBar.barTintColor = UIColor.white
        
        /// Tab bar colors
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.defaultFont(size: 10)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.trinidad, NSFontAttributeName: UIFont.defaultFont(size: 10)], for: .selected)
        
        for (index, tabBarItem) in TabTitles.allValues.enumerated() {
            
            /// Safety check
            guard let item = tabBar.items?[index] else {
                return
            }
            
            /// Make text closer to icons
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.image = UIImage(named: "\(tabBarItem.description.lowercased())_icon")
            item.selectedImage = UIImage(named: "\(tabBarItem.description.lowercased())_icon_selected")
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print(item)
    }
    
    // MARK: - Utilities
    /// Switcher logic
    ///
    /// - Parameter tabTitle: tab title
    func switchTo(title: TabTitles) {
        guard let index = TabTitles.allValues.index(of: title) else {
            return
        }
        
        /// Transition
        selectedIndex = index
        
        /// Add typing indicator to chat
        homeVC.showTypingIndicator()
    }
    
    /// Show typing indicator
    func showTypingIndicator() {
        ez.runThisAfterDelay(seconds: 1) {
            
            self.homeVC.showTypingIndicator()
        }
    }
}

extension MainViewController: LargeNavigationControllerDelegate {
    func switchTo(_ tabTitle: TabTitles) {
        switchTo(title: tabTitle)
    }
}
