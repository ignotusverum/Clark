//
//  AppDelegate.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    /// Shared
    static let shared = UIApplication.shared.delegate as? AppDelegate

    /// Default keychain
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!)

}

