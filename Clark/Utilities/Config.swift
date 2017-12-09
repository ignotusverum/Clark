//
//  Config.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/23/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import Foundation
import SwiftyJSON
import PromiseKit
import TwilioChatClient

let ClarkUserIDKey = "ClarkUserIDKey"
let ClarkUserDataKey = "ClarkUserDataKey"
let ClarkTempChannelID = "ClarkTempChannelID"
let ClarkTwillioTokenKey = "ClarkTwillioTokenKey"
let ClarkInitialFinishedKey = "ClarkInitialFinishedKey"

/// Legacy keys
let LegacyClarkUserIDKey = "tempUserId"
let LegacyClarkInitialFinishedKey = "userCompletedLaunch"

class Config {
    
    /// Hour Data
    var currentDay: HourData?
    
    /// Shared
    static let shared = Config()
    
    /// Permissions
    var permissions: Permissions?
    
    /// Autocomplete data
    var autocompleteData: [AutoCompleteModel] = []
    
    /// Initial settings
    var settings: JSON? {
        didSet {
            /// Safety check
            guard let settings = settings else {
                return
            }
            
            /// Twillio setup
            if let twilio = settings["twilio"].json {
                
                settingsParser(twilio)
            }
        }
    }
    
    /// Current user ID
    static var userID: String? {
        get {
            
            /// Legacy check
            guard let legacyIDKey = UserDefaults.standard.object(forKey: LegacyClarkUserIDKey) as? String else {
                return UserDefaults.standard.object(forKey: ClarkUserIDKey) as? String
            }
            
            /// Clear legacy keys
            UserDefaults.standard.removeObject(forKey: LegacyClarkUserIDKey)
            
            return legacyIDKey
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClarkUserIDKey)
        }
    }
    
    /// Channel ID Associated with user
    static var channelID: String? {
        get {

            return UserDefaults.standard.object(forKey: ClarkTempChannelID) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClarkTempChannelID)
        }
    }
    
    /// Twillio token
    static var twillioToken: String? {
        get {
            return UserDefaults.standard.object(forKey: ClarkTwillioTokenKey) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClarkTwillioTokenKey)
        }
    }
    
    /// Open hours
    var openHours: [HourData] = []
    
    /// Current tutor
    fileprivate var _currentTutor: Tutor?
    var currentTutor: Tutor? {
        set {
            
            _currentTutor = newValue
            
            let defaults = UserDefaults.standard
            if let _currentTutor = _currentTutor, let id = _currentTutor.id {
                
                let userID = NSKeyedArchiver.archivedData(withRootObject: id)
                defaults.set(userID, forKey: ClarkUserDataKey)
            }
            else {
                
                defaults.removeObject(forKey: ClarkUserDataKey)
            }
            
            defaults.synchronize()
        }
        get {
            
            if _currentTutor?.id == nil {
                
                let defaults = UserDefaults.standard
                
                if let tutorIDData = defaults.data(forKey: ClarkUserDataKey),let tutorID = NSKeyedUnarchiver.unarchiveObject(with: tutorIDData) {
                    
                    let tutor = DatabaseManager.defaultStack.fetchOne(From<Tutor>(), Where("\(ModelAttributes.id.rawValue) == %@", tutorID))
                    
                    if let tutor = tutor {
                        
                        _currentTutor = tutor
                    }
                }
            }
            
            return _currentTutor
        }
    }
    
    // MARK: - Utilities
    func settingsParser(_ JSON: JSON) {
        
        /// Twillio token
        Config.twillioToken = JSON["token"].string
        
        if let userID = JSON["user_identity"].string {
            /// User ID
            Config.userID = userID
        }
        
        /// Channel id
        Config.channelID = JSON["primary_channel_id"].string
    }
    
    /// Updating permissions
    func settingPermissions(_ JSON: JSON) {
        
        /// Safety check
        guard let source = JSON["feature_flags"].json else {
            return
        }
        
        permissions = Permissions(source: source)
    }
    
    /// Delete everything, reset channels, perform initial segue
    ///
    /// - Returns: New chat client
    class func resetDataAndConnect()-> Promise<Bool> {
        
        /// Api man
        let apiMan = APIManager.shared
        apiMan.apiKey = nil
        
        /// Config
        let config = Config.shared
        config.currentTutor = nil
        
        /// Shared
        Config.userID = nil
        Config.channelID = nil
        Config.twillioToken = nil
        
        /// Clear DB
        DatabaseManager.clearDB()
        
        /// Create initial channel
        return Promise(value: true)
    }
}

