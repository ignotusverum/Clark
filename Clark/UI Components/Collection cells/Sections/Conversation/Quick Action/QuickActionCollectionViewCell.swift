//
//  QuickActionCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

class QuickActionViewCollectionViewCell: UICollectionViewCell, QuickActionCellProtocol {

    /// Action
    var action: QuickAction!
    
    /// Body label
    lazy var bodyLabel: UILabel = self.generateBodyLabel()
}
