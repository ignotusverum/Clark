//
//  SessionDetailsCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/3/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import CoreGraphics

protocol SessionDetailsCellProtocol {
    
    /// Session
    var session: Session! { get set }
    
    /// Calculated height
    static func calculatedHeight(session: Session)-> CGFloat
}
