//
//  StripeInfo.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/13/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Stripe
import SwiftyJSON
import Foundation

struct StripeInfoJSON {
    
    static let error = "stripe_api_error"
    static let token = "stripe_bank_token"
    
    static let holderName = "bank_account_holder_name"
    static let holderType = "bank_account_holder_type"
}

struct StripeInfo {
    
    /// Golder name
    var holderName: String
    
    /// Holder Type
    var holderType: STPBankAccountHolderType = .individual
    
    /// Stripe token
    var token:String?
    
    /// Error
    var stripeError:String?
    
    /// Networking request attributes
    var attributes: [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["account_holder_name"] = holderName
        
        /// Check holder type
        if holderType == .company {
            dictionary["account_holder_type"] = "business"
        }
        else {
            dictionary["account_holder_type"] = "individual"
        }
        
        /// Stripe token
        dictionary["stripe_bank_token"] = token
        dictionary["stripe_api_error"] = stripeError
        
        return dictionary
    }
    
    init?(source: JSON) {
        guard let holderName = source[StripeInfoJSON.holderName].string,
            let holderType = source[StripeInfoJSON.holderType].string else {
                return nil
        }
        
        self.holderName = holderName
        
        /// Type check
        if holderType.lowercased() == "individual" {
            self.holderType = STPBankAccountHolderType.individual
        }
        else if holderType.lowercased() == "business" {
            self.holderType = STPBankAccountHolderType.company
        }
        
        self.token = source[StripeInfoJSON.token].string
        self.stripeError = source[StripeInfoJSON.error].string
    }
}
