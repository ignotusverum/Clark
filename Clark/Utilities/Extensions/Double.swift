//
//  Double.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/13/17.
//  Copyright © 2017 Clark. All rights reserved.
//

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
