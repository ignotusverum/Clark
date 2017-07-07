//
//  Date.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

extension Date {
    
    
    func yearsFrom(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year!
    }
    
    func monthsFrom(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month!
    }
    
    func weeksFrom(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear!
    }
    
    func daysFrom(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day!
    }
    
    func hoursFrom(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour!
    }
    
    func minutesFrom(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute!
    }
    
    func secondsFrom(_ date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second!
    }
    
    static func convTimestamp(_ date: Date)-> NSAttributedString {
        
        let formatter = DateFormatter()
        formatter.amSymbol = " am"
        formatter.pmSymbol = " pm"
        formatter.dateFormat = timeIs12HourFormat() ? "h:mma" : "H:MM"
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM d"
        
        let day = date.weekday
        let monthDay = monthFormatter.string(from: date)
        let timeString = formatter.string(from: date)
        
        var resultTimestamp = day
        resultTimestamp = "\(resultTimestamp) \(monthDay) at \(timeString)"
        
        let attributedString = NSAttributedString(string: "\n\n\(resultTimestamp)\n\n", attributes: [NSFontAttributeName: UIFont.SFProText(10), NSForegroundColorAttributeName: UIColor.ColorWith(red: 170, green: 170, blue: 170, alpha: 1)])
        
        return attributedString
    }
    
    
    /// Check if current phone format is 12 or 24
    ///
    /// - Returns: true if 12
    static func timeIs12HourFormat()-> Bool {
        
        let formatStringForHours = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: NSLocale.current)
        
        guard let _formatStringForHours = formatStringForHours else {
            return false
        }
        
        let isContainsA = _formatStringForHours.contains("a")
        return isContainsA
    }
}
