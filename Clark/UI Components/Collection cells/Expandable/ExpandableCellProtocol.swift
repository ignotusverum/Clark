//
//  ExpandableCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/1/17.
//  Copyright © 2017 Clark. All rights reserved.
//

protocol ExpandableCellProtocol {
    
    /// Is Open
    var isOpen: Bool! { get set }
    
    /// Calculate height
    static func calculateHeight()-> CGFloat
}
