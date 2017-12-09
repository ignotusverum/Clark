//
//  Copy.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/3/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation

class Copy {
    
    /// Generate Session date copy
    class func sessionDate(session: Session)-> String {
        return session.localStartTime(format: "E, MMM d") ?? ""
    }
    
    /// Generate Session time copy
    class func sessionTime(session: Session)-> String {
        
        /// Get time am/pm
        var timeString = session.localStartTime(format: "h:mm a") ?? ""
        timeString = timeString.length > 0 ? timeString + " • " : ""
        
        /// Get duration
        let durationHours: Int = (session.durationInMinutes?.intValue ?? 0) / 60
        
        /// If hrs > 0 add to final string
        let suffix = durationHours == 1 ? "hour" : "hours"
        timeString = durationHours > 0 ? timeString + "\(durationHours) \(suffix)" : ""
        
        return timeString
    }
}
