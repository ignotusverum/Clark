//
//  TutorAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/22/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import Alamofire
import PromiseKit
import SwiftyJSON

/// Tutor adapter errors
enum TutorAdapterErrors: Error {
    case me
    
    case login
    case signUp
    
    case update
}

class TutorAdapter: SynchronizerAdapter {
    
    /// Login call
    ///
    /// - Parameters:
    ///   - email: Email of current user
    ///   - password: Password for current user
    ///   - channel: Channel associated with user
    /// - Returns: JSON response on success
    class func login(_ email: String, password: String, channelID: String)-> Promise<Tutor?> {
        
        /// Params for request
        let params = ["auth_email": email.lowercased(), "password" : password, "pre_login_channel_sid" : channelID]
        
        /// Networking request
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "login", parameters: ["service_provider_user": params]).then {
            response-> Promise<Tutor?> in
            
            /// Clear old messages
            DatabaseManager.clearDB()
            
            guard let tutorDictionary = response["data"].json, let metaDictionary = response["meta"].json else {
                throw TutorAdapterErrors.login
            }
            
            /// Config settings
            let config = Config.shared
            config.settings = metaDictionary
            
            /// Update auth token
            apiMan.apiKey = metaDictionary[APIManagerJSON.authToken].string
            
            /// Safe to db
            return DatabaseManager.insertSync(Into<Tutor>(), source: tutorDictionary)
            }.then { response-> Promise<Tutor?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Register user
    ///
    /// - Parameters:
    ///   - email: Email associated with user
    ///   - password: Pass
    ///   - channel: Channel associated with user
    /// - Returns: JSON on success
    class func register(_ email: String, password: String, channelID: String)-> Promise<JSON> {
        
        /// Params for request
        let params = ["auth_email": email, "password" : password, "pre_login_channel_sid" : channelID]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "register", parameters: ["sign_up": params]).then { response-> JSON in
            
            /// Clear old messages
            DatabaseManager.clearDB()
            
            guard let _ = response["data"].json, let metaDictionary = response["meta"].json else {
                throw TutorAdapterErrors.signUp
            }
            
            /// Config settings
            let config = Config.shared
            config.settings = metaDictionary
            
            /// Update auth token
            apiMan.apiKey = metaDictionary[APIManagerJSON.authToken].string
            
            return response
        }
    }
    
    /// Onboarding setup
    class func onboarding(key: String)-> Promise<Tutor?> {
        
        /// Params
        let params: [String: Any] = ["data": [], "web_public_token": key, "mobile_secret_token": OnboardingKey]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "me", parameters: params).then { response-> Promise<Tutor?> in
            
            guard let tutorDictionary = response["data"].json, let metaJSON = response["meta"].json else {
                throw TutorAdapterErrors.me
            }
            
            /// Config settings
            let config = Config.shared
            config.settings = metaJSON
            
            /// Update auth token
            apiMan.apiKey = metaJSON[APIManagerJSON.authToken].string

            return DatabaseManager.insertSync(Into<Tutor>(), source: tutorDictionary)
            }.then { response-> Promise<Tutor?> in
                return me()
        }
    }
    
    /// Fetching current tutor object
    ///
    /// - Returns: Tutor object on success
    class func me()-> Promise<Tutor?> {
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "me").then { response-> Promise<Tutor?> in
            
            guard let tutorDictionary = response["data"].json, let metaJSON = response["meta"].json else {
                throw TutorAdapterErrors.me
            }
            
            /// Config settings
            let config = Config.shared
            config.settings = metaJSON
            
            /// Forse update
            if let meta = response["meta"].dictionaryObject {
                VersionManager.saveAndCheckMinVersion(meta: meta)
                
                /// Update permissions
                config.settingPermissions(metaJSON)
            }
            
            /// Update auth token
            apiMan.apiKey = metaJSON[APIManagerJSON.authToken].string
            
            return DatabaseManager.insertSync(Into<Tutor>(), source: tutorDictionary)
            }.then { response-> Promise<Tutor?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Update current tutor with params
    ///
    /// - Parameter dict: Params dict
    class func update(_ dict: [String: Any]?)-> Promise<Tutor?> {
        
        /// Safety check
        guard let dict = dict else {
            return Promise(value: nil)
        }
        
        let dataPams : [String : Any] = ["data":["attributes" : dict]]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "me", parameters: dataPams).then { response-> Promise<Tutor?> in
            
            guard let tutorDictionary = response["data"].json, let metaDictionary = response["meta"].json else {
                throw TutorAdapterErrors.update
            }
            
            /// Config settings
            let config = Config.shared
            config.settings = metaDictionary
            
            /// Update auth token
            apiMan.apiKey = metaDictionary[APIManagerJSON.authToken].string
            
            return DatabaseManager.insertSync(Into<Tutor>(), source: tutorDictionary)
            }.then { response-> Promise<Tutor?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
        }
    }
}
