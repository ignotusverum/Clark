//
//  ConfigAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/23/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PromiseKit
import SwiftyJSON

class ConfigAdapter: SynchronizerAdapter {
    
    /// Return all avaliable hours
    ///
    /// - Returns: JSON on success
    class func hours()-> Promise<JSON> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "clark_hours").then { response-> JSON in
            
            guard let data = response["data"].dictionaryObject, let hoursDictionary = data["attributes"] as? [String: Any] else {
                
                return response
            }
            
            return response
        }
    }
    
    /// Fetch Onboarding flows
    ///
    /// - Returns: List of onboarding flows
    class func onboarding()-> Promise<[OnboardingFlows]> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "onboarding_statuses").then { response-> [OnboardingFlows] in
            
            /// Safety check
            guard let responseJSON = response["data"].array else {
                return []
            }
            
            /// Creating flows
            return responseJSON.flatMap { OnboardingFlows(json: $0) }
        }
    }
    
    /// Fetch channel config
    ///
    /// - Returns: JSON on success
    class func config()-> Promise<String?> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "launch_configs").then { response-> String? in
            
            guard let data = response["data"].json else {
                return nil
            }

            let config = Config.shared
            config.settings = data
            
            return Config.twillioToken
        }
    }
    
    /// Update channel token
    ///
    /// - Parameters:
    ///   - channelID: Channel ID
    ///   - userID: Current user ID
    /// - Returns: JSON on success
    class func updateToken(channelID: String, userID: String)-> Promise<String?> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "launch_configs?channel_id=\(channelID)&user_identity=\(userID)").then { response-> String? in
            
            guard let data = response["data"].json else {
                return nil
            }
            
            let config = Config.shared
            config.settings = data
            
            return Config.twillioToken
        }
    }
}
