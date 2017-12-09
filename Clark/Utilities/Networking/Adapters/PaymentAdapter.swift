//
//  PaymentAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/23/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Stripe
import PromiseKit
import SwiftyJSON

class PaymentAdapter: SynchronizerAdapter {

    /// Create stripe token from bank account info
    ///
    /// - Parameters:
    ///   - accountNumber: Account number
    ///   - routingNumber: Routing number
    ///   - stripeInfo: Stripe info - keys
    /// - Returns: Token on success
    class func stripeToken(accountNumber: String, routingNumber: String, stripeInfo: StripeInfo)-> Promise<STPToken> {
        
        return Promise { fulfill, reject in
         
            /// Create bank params
            let bankParams = STPBankAccountParams()
            bankParams.accountNumber = accountNumber
            bankParams.routingNumber = routingNumber
            bankParams.accountHolderName = stripeInfo.holderName
            bankParams.accountHolderType = stripeInfo.holderType
            bankParams.country = "US"
            bankParams.currency = "usd"
            
            /// Try to create stripe token
            STPAPIClient.shared().createToken(withBankAccount: bankParams, completion: { (token, error) in
                
                /// Safety check
                if let error = error {
                    reject(error)
                }
                
                /// Safety check
                guard let token = token else {
                    reject(GeneralError)
                    return
                }
                
                fulfill(token)
            })
        }
    }
}
