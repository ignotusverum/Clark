//
//  Config.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/23/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import CoreStore
import Foundation

let ClarkUserIDKey = "ClarkUserIDKey"
let ClarkUserDataKey = "ClarkUserDataKey"
let ClarkTempChannelID = "ClarkTempChannelID"

let ClarkShowVideoOnLaunch = "ClarkShowVideoOnLaunch"

class Config {
    
    /// Shared
    static let shared = Config()
    
    /// Current user ID
    static var userID:String? {
        get {
            return UserDefaults.standard.object(forKey: ClarkUserIDKey) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClarkUserIDKey)
        }
    }
    
    /// Channel ID Associated with user
    static var channelID:String? {
        get {
            return UserDefaults.standard.object(forKey: ClarkTempChannelID) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ClarkTempChannelID)
        }
    }
    
    /// Show video Bool
    static var showVideo:Bool? {
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
