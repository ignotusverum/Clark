//
//  VersionManager.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/18/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import StoreKit
import EZSwiftExtensions

class VersionManager : NSObject, SKStoreProductViewControllerDelegate {
    
    private static var singleton = VersionManager()
    
    public static var currentlyBlocking = false
    
    public static func saveAndCheckMinVersion(meta: [String: Any]) {
        guard let minVersionString = meta["minimum_app_version"] as? String else {return}
        
        UserDefaults.standard.set(minVersionString, forKey: "minVersionString")
        checkMinVersionAndShowBlockingUI()
    }
    
    public static func checkMinVersionAndShowBlockingUI() {
        // Find min version and current version
        guard let minimumVersion = UserDefaults.standard.object(forKey: "minVersionString") as? String,
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        // Check if min version is higher than current. If so, BLOCK
        let block = isVersion(minimumVersion, greaterThan: version)
        if block, !currentlyBlocking {
            
            // If blocking message isn't already shown, block UI with link to app store
            ez.runThisAfterDelay(seconds: 15) {
                singleton.showBlockView()
            }
            
            VersionManager.currentlyBlocking = true
        } else if currentlyBlocking {
            singleton.reset(checkAgain: false)
        }  // ELSE: Do nothing, already in the correct state
    }
    
    private weak var showingVC:UIViewController?
    private func showBlockView() {
        guard let topVC = AppDelegate.shared.window?.rootViewController else { return }
        topVC.view.endEditing(true)
        let alertController = UIAlertController(title: "Please upgrade to the latest version of the app to continue to use Clark", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let appStoreAction = UIAlertAction(title: "Go To App Store", style: .default, handler: {[weak self] (action) in
            // Open link to app store update
            let storeViewController = SKStoreProductViewController()
            storeViewController.delegate = self
            
            let parameters = [ SKStoreProductParameterITunesItemIdentifier : "1186832424"]
            storeViewController.loadProduct(withParameters: parameters) {[weak self] (loaded, error) -> Void in
                if loaded {
                    // Parent class of self is UIViewContorller
                    self?.showingVC = topVC
                    
                    topVC.present(storeViewController, animated: true, completion: { _ in
                        print("yo")
                    })
                } else {
                    VersionManager.currentlyBlocking = false
                }
            }
            
        })
        alertController.addAction(appStoreAction)
        
        topVC.present(alertController, animated: true, completion: nil)
    }
    
    private func reset(checkAgain:Bool) {
        guard let topVC = showingVC else {return}
        topVC.dismiss(animated: true) {
            self.showingVC = nil
            VersionManager.currentlyBlocking = false
            if checkAgain { VersionManager.checkMinVersionAndShowBlockingUI() }
        }
    }
    
    // SKStoreProductViewControllerDelegate
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        reset(checkAgain: true)
    }
    
    // MARK: - Helper Functions
    
    // Loop through minVersion components and compare each with the current version
    // 1.1 is greater than 1.0.1
    // 2.0 is greater than 1.9.9.9.9
    static func isVersion(_ a:String, greaterThan b:String) -> Bool {
        var aIsHigher = false
        
        // Split into component seperated by periods (i.e "1.2.3" -> ["1", "2", "3"])
        let aComponents = a.components(separatedBy: ".")
        let bComponents = b.components(separatedBy: ".")
        
        // Loop through all components and compare similar components between the two versions
        for (n, comp) in aComponents.enumerated() {
            
            // Find the equivalent component for the current version. If none exists, assume a value of 0
            var currentVerionComponent = "0"
            if bComponents.count > n { currentVerionComponent = bComponents[n] }
            
            if let currentInt = Int(currentVerionComponent), let minInt = Int(comp) {
                if currentInt == minInt {
                    // Both components are equal, move to the next component and evaluate again. do nothing specific this iteration and let loop continue.
                } else if currentInt < minInt {
                    // Version a is greater than version b.
                    aIsHigher = true
                    break
                } else {
                    // version b is higher than version a.
                    break
                }
            } else {
                // not a valid integer, break here and assume no blocking. error with the min version string.
                break
            }
        }
        return aIsHigher
    }
    
    private static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
