//
//  KickoffManager.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/22/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Stripe
import Alamofire
import PromiseKit
import SwiftyJSON

public class KickoffManager: NetworkingProtocol {

    /// Shared manger
    static let shared = KickoffManager()
    
    /// Header setup
    var headers = [
        "Accept": "*/*",
        "Content-Type": "application/json"
    ]
    
    /// Api key
    var apiKey: String? {
        get {
            
            let keychain = AppDelegate.shared?.keychain
            let apiKey = keychain?[NetworkingManagerKickoffTokenKey]
            
            return apiKey
        }
        set {
            
            let keychain = AppDelegate.shared?.keychain
            keychain?[NetworkingManagerKickoffTokenKey] = newValue
        }
    }
    
    /// Default manager setup
    var manager = Alamofire.SessionManager.default
    
    static let contentTypeString = "application/vnd.api+json"
    
    /// Header configuration
    func configureHeader() {
        headers["x-api-key"] = KickoffKey
        headers["Content-Type"] = KickoffManager.contentTypeString
    }
    
    /// Base URL setup
    func baseURL(path: String) -> URL {
        return URL(string: "https://\(KickoffURL)/\(path)")!
    }
}
