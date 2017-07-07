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

let ClarkUserIDKey = "ClarkUserIDKey"
let ClarkUserDataKey = "ClarkUserDataKey"
let ClarkTempChannelID = "ClarkTempChannelID"
let ClarkTwillioTokenKey = "ClarkTwillioTokenKey"
let ClarkShowVideoOnLaunch = "ClarkShowVideoOnLaunch"
let ClarkInitialFinishedKey = "ClarkInitialFinishedKey"

class Config {
    
    /// Shared
    static let shared = Config()
    
    /// Initial settings
    var settings: JSON? {
        didSet {
            /// Safety check
            guard let settings = settings else {
                return
            }
            
            /// Twillio setup
            if let twillio = settings["unauthenticated_twilio"].json {
                
                /// Twillio token
                Config.twillioToken = twillio["token"].string
                
                /// User ID
                Config.userID = twillio["user_identity"].string
                
                /// Channel id
                Config.channelID = twillio["primary_channel_id"].string
            }
            
            /// Show video
            Config.showVideo = settings["show_video"].bool
        }
    }
    
    /// Initial finished
    static var isInitialFinished: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: ClarkInitialFinishedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClarkInitialFinishedKey)
        }
    }
    
    /// Current user ID
    static var userID: String? {
        get {
            return UserDefaults.standard.object(forKey: ClarkUserIDKey) as? String
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
            return UserDefaults.standard.object(forKey: "TOKEN") as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "TOKEN")
        }
    }
    
    /// Show video Bool
    static var showVideo: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: ClarkShowVideoOnLaunch)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClarkShowVideoOnLaunch)
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
}
