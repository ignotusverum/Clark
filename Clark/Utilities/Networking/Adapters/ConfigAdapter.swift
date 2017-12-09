//
//  ConfigAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/23/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PromiseKit
import SwiftyJSON
import EZSwiftExtensions

class ConfigAdapter: SynchronizerAdapter {
    
    /// Return all avaliable hours
    ///
    /// - Returns: JSON on success
    class func hours()-> Promise<JSON> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "clark_hours").then { response-> JSON in
            
            guard let data = response["data"].json, let hoursJSON = data["attributes"].json else {
                
                return response
            }
            
            /// Getting JSON daya
            var hoursData: [HourData?] = []
            for key in hoursJSON.dictionaryValue.keys {
                
                hoursData.append(HourData(day: key, timeZone: hoursJSON["user_timezone"].string, hours: hoursJSON["\(key)"].array))
            }
            
            /// Set current hours config
            let config = Config.shared
            config.openHours = hoursData.flatMap { $0 }
            config.currentDay = config.openHours.filter { $0.day.lowercased() == Date().weekday.lowercased() }.first
            
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
    class func config()-> Promise<(token: String, identity: String)> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "launch_configs").then { response-> (token: String, identity: String) in
            
            guard let data = response["data"].json else {
                return ("", "")
            }
            
            // Forse update
            if let meta = response["meta"].dictionaryObject {
                VersionManager.saveAndCheckMinVersion(meta: meta)
            }

            let config = Config.shared
            config.settings = data
            
            return (Config.twillioToken ?? "" , Config.userID ?? "" )
        }
    }
    
    /// Update channel token
    ///
    /// - Parameters:
    ///   - channelID: Channel ID
    ///   - userID: Current user ID
    /// - Returns: JSON on success
    class func updateToken(channelID: String, userID: String)-> Promise<(token: String, identity: String)> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "launch_configs?channel_id=\(channelID)&user_identity=\(userID)").then { response-> (token: String, identity: String) in
            
            guard let data = response["data"].json else {
                return ("", "")
            }
            
            let config = Config.shared
            config.settings = data
            
            return (Config.twillioToken ?? "" , Config.userID ?? "" )
        }
    }
}
