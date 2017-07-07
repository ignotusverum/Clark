//
//  HourData.swift
//  Clark
//
//  Created by Jay Chmilewski on 4/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON
import Foundation
import UserNotifications

struct HourDataJSON {
    
    static let sunday = "sunday"
    static let monday = "monday"
    static let tuesday = "tuesday"
    static let wednesday = "wednesday"
    static let thursday = "thursday"
    static let friday = "friday"
    static let saturday = "saturday"
    
    static let week: [String] = [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
}

struct HourData {
    
    // MARK: - Properties
    var hours: [JSON]
    var day: String    // i.e "Sunday"
    var dayInt: Int  // 1 = Sunday, 2 = Monday, ..., 7 = Saturday
    var timeZone: String

    init?(day: String?, timeZone: String?, hours: [JSON]?) {
        
        guard let day = day, let timeZone = timeZone, let hours = hours else {
            return nil
        }
        
        /// String day
        self.day = day.replacingOccurrences(of: "_open", with: "")
        
        /// Int day
        self.dayInt = HourDataJSON.week.lastIndex(of: self.day) ?? 0
        
        /// Timezone
        self.timeZone = timeZone
        
        /// Hours
        self.hours = hours
    }
    
    // Main public property used to determine if clarkbot is asleep on this day
    public var isCurrentlyOpen: Bool {
        
        for timesDict in hours {
            
            guard let startHour = timesDict["start"].json?["local_hour"].int,
                let startMinute = timesDict["start"].json?["local_minute"].int,
                let endHour = timesDict["end"].json?["local_hour"].int,
                let endMinute = timesDict["end"].json?["local_minute"].int,
                let newStart = timeWith(hours: startHour, minutes: startMinute, timeZoneString: timeZone),
                let newEnd = timeWith(hours: endHour, minutes: endMinute, timeZoneString: timeZone),
                newStart < newEnd else { return false }
            
            return (newStart...newEnd).contains(Date())
        }
        
        return false
    }
    
    // MARK: - Public methods
    
    // Function returns the closest "boundary date" to right now. A boundary date is any time when clark flips from offline to online or vice versa.
    // daysOffsetFromCurrent = number of days ahead of right now to analyze. i.e. daysOffsetFromCurrent = 3 would push forward all dates analyzed by 3 days. This is usually only used when all hours from the current day are too early so the algorithm moves on to look at tomorrows times. In this situtation, the first start time of the day should always be returned.
    public func nextBoundaryTime(daysOffsetFromCurrent:Int = 0) -> Date? {
        var nextDate: Date?
        
        // Loop through times and find the closest one to now BUT is still in the future. If none exist, return nil and the algorithm will move on to analyze the next day.
        for timesDict in hours {
            
            guard let startHour = timesDict["start"].json?["local_hour"].int,
                let startMinute = timesDict["start"].json?["local_minute"].int,
                let endHour = timesDict["end"].json?["local_hour"].int,
                let endMinute = timesDict["end"].json?["local_minute"].int,
                var newStart = timeWith(hours: startHour, minutes: startMinute, timeZoneString: timeZone),
                var newEnd = timeWith(hours: endHour, minutes: endMinute, timeZoneString: timeZone) else { return nil }
            
            // If daysOffsetFromCurrent is valid, add extra time to the analysis dates before continuing.
            if daysOffsetFromCurrent > 0 {
                let cal = Calendar(identifier: Calendar.Identifier.gregorian)
                var dayComponent = DateComponents()
                dayComponent.day = daysOffsetFromCurrent
                
                if let start = cal.date(byAdding: dayComponent, to: newStart),let end = cal.date(byAdding: dayComponent, to: newEnd) {
                    newStart = start
                    newEnd = end
                }
            }
            
            // Check if date is in the future and closer to now than the current closest date so far in the loop. If no date is saved yet, set the date automatically (IF IN THE FUTURE).
            let timeTillStart = newStart.timeIntervalSinceNow
            let timeTillEnd = newEnd.timeIntervalSinceNow
            if timeTillStart > 0 {
                if nextDate == nil {
                    nextDate = newStart
                } else if timeTillStart < nextDate!.timeIntervalSinceNow {
                    nextDate = newStart
                }
            }
            if timeTillEnd > 0 {
                if nextDate == nil {
                    nextDate = newEnd
                } else if timeTillEnd < nextDate!.timeIntervalSinceNow {
                    nextDate = newEnd
                }
            }
        }
        
        return nextDate
    }
        
    private func timeWith(hours:Int, minutes:Int, timeZoneString:String) -> Date? {
        guard let timeZone = TimeZone(identifier: timeZoneString) else {return nil}
    
        let hoursNumberInSeconds = hours * 60 * 60
        let minutesNumberInSeconds = minutes * 60
        let totalTimeSinceMidnightInSeconds = hoursNumberInSeconds + minutesNumberInSeconds
        
        var calendarForServerRecommendedTimeZone = NSCalendar.current
        calendarForServerRecommendedTimeZone.timeZone = timeZone
        
        let startOfTodayInServerRecommendedTimeZone = calendarForServerRecommendedTimeZone.startOfDay(for: Date())
        let timeInServerRecommendedTimeZone = startOfTodayInServerRecommendedTimeZone.addingTimeInterval(Double(totalTimeSinceMidnightInSeconds))
        
        let source_timezone = timeZone
        let local_timezone = NSCalendar.current.timeZone
        let source_EDT_offset = source_timezone.secondsFromGMT(for: timeInServerRecommendedTimeZone)
        let destination_EDT_offset = local_timezone.secondsFromGMT(for: timeInServerRecommendedTimeZone)
        let time_interval : TimeInterval = Double(destination_EDT_offset - source_EDT_offset)
        
        let finalTimeAsDate = Date(timeInterval: time_interval, since: timeInServerRecommendedTimeZone)
        
        return finalTimeAsDate
    }
}
