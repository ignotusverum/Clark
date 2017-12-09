//
//  DividerAccessoryCellprotocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol DividerCellProtocol {
    
    /// Divider view
    var dividerView: UIView { get set }
}

extension DividerCellProtocol where Self: UICollectionViewCell {
    
    /// Divider view
    func generateDividerView()-> UIView {
        
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        return view
    }
    
    /// Setup divider layout
    func dividerLayout() {
        
        /// Divider
        addSubview(dividerView)
        
        /// Divider view
        dividerView.snp.updateConstraints { maker in
            maker.left.equalTo(25)
            maker.right.equalTo(self).offset(-25)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(self).offset(-1)
        }
    }
}
