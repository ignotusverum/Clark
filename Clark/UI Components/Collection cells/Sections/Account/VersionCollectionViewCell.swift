//
//  VersionCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation
import EZSwiftExtensions

class VersionCollectionViewCell: UICollectionViewCell {
    
    /// Title label
    lazy var titleLabel: UILabel = {
        
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.AvenirNextRegular(size: 18)
        label.textColor = UIColor.lightGray.withAlphaComponent(0.8)
        
        return label
    }()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// title label
        addSubview(titleLabel)
        titleLabel.text = "v \(ez.appVersion!) (\(ez.appBuild!))"
        
        /// title label layout
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
    }
}
