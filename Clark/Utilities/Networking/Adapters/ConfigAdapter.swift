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
    class func config()-> Promise<JSON> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "launch_configs").then { response-> JSON in
            
            guard let data = response["data"].dictionaryObject else {
                return response
            }
            
//            LaunchChannelManager.showVideo = data["show_video"] as? Bool
//            
//            if let tokenData = data["unauthenticated_twilio"] as? [String:Any] {
//                LaunchChannelManager.token = tokenData["token"] as? String
//                LaunchChannelManager.channelId = tokenData["primary_channel_id"] as? String
//                LaunchChannelManager.userId = tokenData["user_identity"] as? String
//            }
            
            return response
        }
    }
    
    /// Update channel token
    ///
    /// - Parameters:
    ///   - channelID: Channel ID
    ///   - userID: Current user ID
    /// - Returns: JSON on success
    class func updateToken(channelID: String, userID: String)-> Promise<JSON> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "launch_configs?channel_id=\(channelID)&user_identity=\(userID)").then { response-> JSON in
            
            return response
        }
    }
}
