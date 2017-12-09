//
//  TCHChannel.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/18/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import Foundation
import PromiseKit
import TwilioChatClient

extension TCHChannel {
    
    /// Send message with wrapper
    ///
    /// - Parameter message: message params
    /// - Returns: Result to parse
    func send(options: TCHMessageOptions)-> Promise<TCHResult> {
        
        /// Promise wrapper
        return Promise { fulfill, reject in
            
            messages?.sendMessage(with: options, completion: { result in
              
                /// Safety check
                guard result.0.isSuccessful() else {
                    reject(GeneralError)
                    return
                }
                
                fulfill(result.0)
            })
        }
    }
    
    /// Fetch message with promise
    ///
    /// - Parameter messageIndex: message index
    /// - Returns: return message on success
    func fetchMessage(messageIndex: NSNumber)-> Promise<(TCHMessage, Message?)> {
        
        /// Promise wrapper
        return Promise { fulfill, reject in
            
            /// Fetch message from twillio
            messages?.message(withIndex: messageIndex, completion: { (result, message) in
            
                /// Throw if error
                if !result.isSuccessful() {
                    reject(result.error ?? GeneralError)
                    return
                }
                
                /// Safety check for message
                guard let message = message else {
                    reject(GeneralError)
                    return
                }
                
                /// Updated import source
                let importSource = (message: message, channelID: self.sid ?? "")
                DatabaseManager.insertASync(Into<Message>(), source: importSource).then { response-> Promise<Message?> in
                    
                    return DatabaseManager.fetchExisting(response)
                    }.then { response-> Void in
                
                        /// Successfully fetched
                        fulfill((message, response))
                    
                    }.catch { error in
                        /// Error
                        fulfill((message, nil))
                }
            })
        }
    }
}
