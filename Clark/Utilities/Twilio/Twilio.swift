//
//  Twilio.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import PromiseKit
import TwilioChatClient
import TwilioAccessManager

extension TCHChannel {
    
    /// Wrap getMessageCount in promise
    /** Fetch the number of messages on this channel.
     
     Available even if the channel is not yet synchronized.
     
     Available even if the channel is not yet synchronized.  Subsequent calls of this
     method prior to the local cache's expiry will return cached values.
     
     @param completion Completion block that will speciy the requested count.  If no completion block is specified, no operation will be executed.
     */
    open func getMessageCount()-> Promise<(TCHResult?, UInt)> {
        return Promise { fulfill, reject in
            self.getMessagesCount(completion: { (result, number) in
                fulfill((result, number))
            })
        }
    }
}

extension TCHMessages {
    
    /// Wrap getAfter in promise
    /** Fetches at most `count` messages inclulding and subsequent to the specified `index`.  This will return locally cached messages if they are all available or may require a load from the server.
     
     @param index The starting point for the request.
     @param count The number of succeeding messages to return.
     @param completion Completion block that will specify the result of the operation as well as the requested messages if successful.  If no completion block is specified, no operation will be executed.
     */
    open func getAfter(_ index: UInt, withCount count: UInt)-> Promise<(TCHResult?, [TCHMessage]?)> {
        return Promise { fulfill, reject in
            
            self.getAfter(index, withCount: count, completion: { (result, messages) in
                fulfill((result, messages))
            })
        }
    }
}
