//
//  TutorAdapter.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/22/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import Alamofire
import PromiseKit
import SwiftyJSON

/// Tutor adapter errors
enum TutorAdapterErrors: Error {
    case me
    
    case login
    case signUp

    case update
}

class TutorAdapter: SynchronizerAdapter {

    /// Login call
    ///
    /// - Parameters:
    ///   - email: Email of current user
    ///   - password: Password for current user
    ///   - channel: Channel associated with user
    /// - Returns: JSON response on success
    class func login(_ email: String, password: String, channelID: String)-> Promise<Tutor?> {
        
        /// Params for request
        let params = ["auth_email": email, "password" : password, "pre_login_channel_sid" : channelID]
        
        /// Networking request
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "login", parameters: ["service_provider_user" : params]).then {
            response-> Promise<Tutor?> in
            
            guard let tutorDictionary = response["data"].json, let metaDictionary = response["meta"].json else {
                throw TutorAdapterErrors.login
            }
            
            /// CHECK FOR META HERE
            
            /// Safe to db
            return DatabaseManager.insertASync(Into<Tutor>(), source: tutorDictionary)
            }.then { response-> Promise<Tutor?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Register user
    ///
    /// - Parameters:
    ///   - email: Email associated with user
    ///   - password: Pass
    ///   - channel: Channel associated with user
    /// - Returns: JSON on success
    class func register(_ email: String, password: String, channelID: String, moc: NSManagedObjectContext)-> Promise<Tutor?> {
        
        /// Params for request
        let params = ["auth_email": email, "password" : password, "pre_login_channel_sid" : channelID]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "register", parameters: ["sign_up": params]).then { response-> Promise<Tutor?> in
            
            guard let tutorDictionary = response["data"].json, let metaDictionary = response["meta"].json else {
                throw TutorAdapterErrors.signUp
            }
            
            return DatabaseManager.insertASync(Into<Tutor>(), source: tutorDictionary)
            }.then { response-> Promise<Tutor?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Fetching current tutor object
    ///
    /// - Returns: JSON on success
    class func fetchMe()-> Promise<Tutor?> {
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.get, path: "me").then { response-> Promise<Tutor?> in
            
            guard let tutorDictionary = response["data"].json, let metaJSON = response["meta"].json else {
                throw TutorAdapterErrors.me
            }
            
            return DatabaseManager.insertASync(Into<Tutor>(), source: tutorDictionary)
            }.then { response-> Promise<Tutor?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Update current tutor with params
    ///
    /// - Parameter dict: Params dict
    /// - Returns: JSON on success
    class func update(_ dict: [String: Any]?)-> Promise<Tutor?> {
        
        /// Safety check
        guard let dict = dict else {
            return Promise(value: nil)
        }
        
        //let parameters : Parameters = ["attributes" : attributes]
        let dataPams : [String : Any] = ["data":["attributes" : dict]]
        
        /// Networking
        let apiMan = APIManager.shared
        return apiMan.request(.post, path: "me", parameters: dataPams).then { response-> Promise<Tutor?> in
            
            guard let tutorDictionary = response["data"].json, let metaDictionary = response["meta"].json else {
                throw TutorAdapterErrors.update
            }
         
            /// Update meta
            
            return DatabaseManager.insertASync(Into<Tutor>(), source: tutorDictionary)
            }.then { response-> Promise<Tutor?> in
                /// Fetch db object
                return DatabaseManager.fetchExisting(response)
        }
    }
    
    /// Add student script
    ///
    /// - Parameter tutorID: Tutor ID
    /// - Returns: JSON on success
    class func addStudent(tutorID: String)-> Promise<JSON> {
        
        /// Attributes
        let attributes = ["tutor_id": tutorID]
        let params : [String : Any] = ["data": ["attributes" : attributes]]
        
        /// Networking
        let kickoffMan = KickoffManager.shared
        return kickoffMan.request(.post, path: "add-students", parameters: params)
    }
}
