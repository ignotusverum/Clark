//
//  Dictionary.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func combine(_ other: Dictionary) {
        for (key,value) in other {
            updateValue(value, forKey:key)
        }
    }
}

