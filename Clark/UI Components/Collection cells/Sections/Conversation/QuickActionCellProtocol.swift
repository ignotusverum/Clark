//
//  QuickActionCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol QuickActionCellProtocol {
    
    /// Body label
    var bodyLabel: UILabel { get set }
}

extension QuickActionCellProtocol {
    
    /// Generate label
    func generateBodyLabel()-> UILabel {
        
        let label = UILabel()
        
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.AvenirNextRegular(size: 17)
        
        return label
    }
}
