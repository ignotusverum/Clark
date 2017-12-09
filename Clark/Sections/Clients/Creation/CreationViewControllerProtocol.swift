//
//  CreationViewControllerProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/15/17.
//  Copyright © 2017 Clark. All rights reserved.
//

protocol CreationViewControllerProtocol {
    
    /// Collection view
    var collectionView: UICollectionView { get set }
    
    /// Title
    var navigationTitle: String { get set }
    
    /// Curstom initialization
    init(currentStep: Int, numberOfSteps: Int, title: String)
    
    /// Progress steps
    var currentStep: Int { get set }
    var numberOfSteps: Int { get set }
}

extension CreationViewControllerProtocol where Self: UIViewController {
    
    init(currentStep: Int = 0, numberOfSteps: Int = 0, title: String) {
        self.init()
        
        /// Controller setup
        controllerSetup()
    }
    
    /// Controller setup
    func controllerSetup() {
        
        setTitle(navigationTitle)
        
        // Setup banner code
        BannerManager.manager.viewController = self
        BannerManager.manager.errorMessageHiddenForCategory = { category in
            print(category)
        }
        
        /// Check if more than one controller
        guard let navController = navigationController, navController.viewControllers.count == 1 else {
            
            /// Back icon
            setCustomBackButton(image: #imageLiteral(resourceName: "back_icon")) {
                self.popVC()
            }
            
            return
        }
        
        /// Back icon
        setCustomBackButton(image: #imageLiteral(resourceName: "close_icon")) {
            self.navigationController?.heroModalAnimationType = .cover(direction: .down)
            self.navigationController?.hero_dismissViewController()
        }
    }
}
