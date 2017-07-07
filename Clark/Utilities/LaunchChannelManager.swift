//
//  LaunchChannelManager.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Alamofire
import PromiseKit

class LaunchChannelManager {
    
    // MARK: - Public methods
    // Returns true if the channel is new, false if not
    class func createNewChannelOrUpdate()-> Promise<(token: String, identity: String)> {
        
        /// Check if needed to update
        if let userId = Config
            .userID, let channelId = Config.channelID {
            
            return ConfigAdapter.updateToken(channelID: channelId, userID: userId)
        }
        
        /// Initial connect
        return ConfigAdapter.config()
    }
}
