//
//  LaunchChannelManager.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

class LaunchChannelManager {
    
    // MARK: - Public methods
    // Returns true if the channel is new, false if not
    class func createNewChannelOrUpdate()-> Promise<Bool> {
        return Promise { fulfill, reject in
            
            if let userId = Config
                .userID, let channelId = Config.channelID {
                
                ConfigAdapter.updateToken(channelID: channelId, userID: userId).then { _ in
                    fulfill(false)
                    }.catch { error in
                        print(error)
                }
            }
            else {
                
                ConfigAdapter.config().then { _ in
                    fulfill(true)
                    }.catch { error in
                        print(error)
                }
            }
        }
    }
}
