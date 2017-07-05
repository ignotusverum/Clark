//
//  APIManager.swift
//  Clark
//
//  Created by Ryan Phillip Thomas on 11/30/16.
//  Copyright © 2016 Clark. All rights reserved.
//

import Stripe
import Alamofire
import PromiseKit
import SwiftyJSON

public class APIManager: NetworkingProtocol {
    
    /// Shared manger
    static let shared = APIManager()
    
    /// Header setup
    var headers = [
        "Accept": "*/*",
        "Content-Type": "application/json"
    ]
    
    /// Api key
    var apiKey: String? {
        get {

            let keychain = AppDelegate.shared?.keychain
            let accessTokenOld = keychain?[NetworkingManagerAccessTokenKey]

            return accessTokenOld
        }
        set {

            let keychain = AppDelegate.shared?.keychain
            keychain?[NetworkingManagerAccessTokenKey] = newValue
        }
    }
    
    /// Default manager setup
    var manager = Alamofire.SessionManager.default
  
    static let contentTypeString = "application/vnd.api+json"
  
    /// Header configuration
    func configureHeader() {
        
        /// Safety check
        guard let accessToken = apiKey, accessToken.length > 1, let deviceID  = UIDevice.idForVendor() else {
            return
        }
        
        headers["Device-Id"] = deviceID
        headers["Authorization"] = accessToken
        headers["Content-Type"] = APIManager.contentTypeString
    }
    
    /// Base URL setup
    func baseURL(path: String) -> URL {
        return URL(string: "https://\(hostName)/v\(hostVersion)/\(path)")!
    }
}
