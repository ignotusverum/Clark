//
//  ScrollToToday.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/27/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class ScrollToTodayButton: UIButton {

    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor.dodgerBlue
        setTitle("Scroll to Today", for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        
        titleLabel?.font = UIFont.defaultFont(size: 17)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
