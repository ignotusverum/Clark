//
//  JSON.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/16/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SwiftyJSON
import PhoneNumberKit

extension JSON {
    
    public var nsString: NSString? {
        
        switch type {
        case .string: return NSString(string: object as! String)
        default: return nil
        }
    }
    
    public var price: NSNumber? {
        
        switch type {
        case .number:
            
            let floatObject = Float(object as! Int)
            let priceDivider = Float(100)
            
            return NSNumber(value: floatObject/priceDivider)
        default:
            return nil
        }
    }
    
    public var json: JSON? {
        
        switch type {
        case .dictionary: return JSON(object)
        default: return nil
        }
    }
    
    public var phone: String? {
        
        switch self.type {
        case .string:
            
            do {
                
                let phoneKit = PhoneNumberKit()
                
                let numberPhone = try phoneKit.parse(object as! String, withRegion: "US")
                
                let formatedPhone = phoneKit.format(numberPhone, toType: .national)
                
                return formatedPhone
            }
            catch {
                return nil
            }
        default:
            return nil
        }
    }
    
    public var date: Date? {
        
        switch type {
        case .string:
            return JSONFormatter.jsonDateFormatter.date(from: object as! String)
        default:
            return nil
        }
    }
    
    public var dateTime: Date? {
        
        switch type {
        case .string:
            return JSONFormatter.jsonDateTimeFormatter.date(from: object as! String)
        default:
            return nil
        }
    }
    
    public var boolNumber: NSNumber? {
        
        switch type {
        case .bool: return NSNumber(value: object as! Bool)
        default:
            return nil
        }
    }
}

class JSONFormatter {
    
    fileprivate static var internalJsonDateFormatter: DateFormatter?
    fileprivate static var internalJsonDateTimeFormatter: DateFormatter?
    
    static var jsonDateFormatter: DateFormatter {
        if (internalJsonDateFormatter == nil) {
            internalJsonDateFormatter = DateFormatter()
            internalJsonDateFormatter!.dateFormat = "yyyy-MM-dd"
        }
        return internalJsonDateFormatter!
    }
    
    static var jsonDateTimeFormatter: DateFormatter {
        if (internalJsonDateTimeFormatter == nil) {
            internalJsonDateTimeFormatter = DateFormatter()
            internalJsonDateTimeFormatter!.dateFormat = "yyyy-MM-dd'T'HH:mm:ss Z"
        }
        return internalJsonDateTimeFormatter!
    }
}
