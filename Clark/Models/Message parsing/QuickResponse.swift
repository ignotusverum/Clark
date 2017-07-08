//
//  QuickResponse.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

public enum QuickReplyType: String {
    case text = "text"
    case emoji = "emoji"
}

struct QuickReply {
    
    var type: QuickReplyType?
    var body: String
    
    init?(source: JSON) {
        
        guard let typeString = source["type"].string, let body = source["body"].string else {
            return nil
        }
        
        /// Body
        self.body = body
        
        /// Type
        self.type = QuickReplyType(rawValue: typeString)
    }
}
