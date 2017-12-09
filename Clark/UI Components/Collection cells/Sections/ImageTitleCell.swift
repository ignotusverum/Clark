//
//  ImageTitleCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/31/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class ImageTitleCell: UICollectionViewCell, SimpleTitleCellProtocol {
    
    /// Simple title
    var text: String! {
        didSet {
            
            /// Title
            simpleTitleLabel.text = text
        }
    }
    
    /// Image 
    var image: UIImage! {
        didSet {
            
            /// Image view setup
            imageView.image = image
        }
    }
    
    /// Image view
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor.trinidad
        
        return imageView
    }()
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    // MARK: - Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Image view
        addSubview(imageView)
        
        /// Image view layout
        imageView.snp.updateConstraints { maker in
            maker.left.equalTo(24)
            maker.width.equalTo(30)
            maker.height.equalTo(30)
            maker.centerY.equalTo(self)
        }
        
        /// Simple layout
        addSubview(simpleTitleLabel)
        
        simpleTitleLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.left.equalTo(36 + 20 + 16)
            maker.right.equalTo(self).offset(-24)
            maker.bottom.equalTo(self)
        }
    }
}
