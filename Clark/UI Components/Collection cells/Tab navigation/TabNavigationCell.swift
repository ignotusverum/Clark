//
//  TabNavigationCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class TabNavigationCell: UICollectionViewCell {
    
    /// Type
    var type: TopNavigationDatasourceType! {
        didSet {
            
            /// Title
            titleLabel.text = type.rawValue
        }
    }
    
    /// Title label
    lazy var titleLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.defaultFont(style: .medium, size: 16)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Title
        addSubview(titleLabel)
        
        /// Title layout
        titleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.bottom.equalTo(self).offset(-1)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
    }
    
    /// Size calculation
    class func widthCalculation(type: TopNavigationDatasourceType)-> CGFloat {
        return type.rawValue.width(usingFont: UIFont.defaultFont(style: .medium, size: 17))
    }
}
