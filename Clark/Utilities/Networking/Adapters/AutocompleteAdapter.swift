//
//  AutocompleteAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/23/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreData
import PromiseKit
import SwiftyJSON

class AutocompleteAdapter: SynchronizerAdapter {
    
    /// Fetch autocomplete list
    ///
    /// - Returns: JSON on sucess
    class func fetch()-> Promise<[AutoCompleteModel]> {
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "chat_autocomplete_scripts").then { response-> [AutoCompleteModel] in
            
            /// Result array
            var result: [AutoCompleteModel] = []
            
            /// Safety check
            guard let autocompletes = response["data"].array else {
                return result
            }
            
            /// Enumerating
            for autoCompleteJSON in autocompletes {
                
                if let model = AutoCompleteModel(attributes: autoCompleteJSON) {
                    result.append(model)
                }
            }
            
            /// Update config
            let config = Config.shared
            config.autocompleteData = result
            
            return result
        }
    }
}

