//
//  LearningPlanDetailsDimentionCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/15/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class LearningPlanDetailsDimentionCell: UICollectionViewCell, DividerCellProtocol, SimpleTitleCellProtocol {
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Dimentions
    var dimentions: [ProgressDimention] = []
    
    /// Text
    var text: String! {
        didSet {
            
            simpleTitleLabel.text = text
            simpleTitleLabel.font = UIFont.defaultFont(style: .medium, size: 18)
        }
    }
    
    /// Title label
    lazy var simpleTitleLabel: UILabel = self.generateSimpleTitleLabel()
    
    
    /// Collection View
    var collectionView: UICollectionView = {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        collectionView.isScrollEnabled = false
        
        /// Cell registration
        collectionView.register(TitleBottomDescriptionSelectionCell.self, forCellWithReuseIdentifier: "\(TitleBottomDescriptionSelectionCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
     
        /// Collection view
        addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection view layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(44)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
            maker.bottom.equalTo(self)
        }
        
        /// Divider layout
        dividerLayout()
        
        /// Simple title
        addSubview(simpleTitleLabel)
        simpleTitleLabel.textColor = textColor
        
        /// Title label layout
        simpleTitleLabel.snp.updateConstraints { maker in
            maker.left.equalTo(25)
            maker.right.equalTo(self).offset(-25)
            maker.height.equalTo(20)
            maker.top.equalTo(24)
        }
    }
    
    /// Calculate height for cell
    class func calculateDimentionHeight(_ progressDimention: ProgressDimention, isLast: Bool = false)-> CGFloat {
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        let titleHeight: CGFloat = 18 + 54 + 12
        var textHeight: CGFloat = 0
        for dimention in progressDimention.descriptions {
            
            let copy = dimention
            textHeight += copy.heightWithConstrainedWidth(screenWidth - 48, font: UIFont.defaultFont(style: .light, size: 16))
        }
        
        let shouldAddSpace: CGFloat = isLast ? 10 : 0
        return progressDimention.descriptions.count > 0 ? titleHeight + textHeight + shouldAddSpace : 0
    }
    
    /// Calculate main cell size
    class func calculateHeight(_ progressDimentions: [ProgressDimention])-> CGFloat {
        return progressDimentions.count == 0 ? 0 : progressDimentions.map{ calculateDimentionHeight($0, isLast: progressDimentions.last == $0) }.reduce(0, +) + 44
    }
}

// MARK: - CollectionView Datasource
extension LearningPlanDetailsDimentionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        /// Calculate cell size
        let dimention = dimentions[indexPath.row]
        return CGSize(width: collectionView.frame.width, height: LearningPlanDetailsDimentionCell.calculateDimentionHeight(dimention))
    }
}

// MARK: - CollectionView Delegate
extension LearningPlanDetailsDimentionCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

// MARK: - CollectionView Datasource
extension LearningPlanDetailsDimentionCell: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return dimentions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {

        let dimention = dimentions[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleBottomDescriptionSelectionCell.self)", for: indexPath) as! TitleBottomDescriptionSelectionCell
        
        /// Dimention name
        cell.text = dimention.name
        
        cell.shouldHaveTopInset = indexPath.row == 0
        
        /// Description
        var descriptionString: String = ""
        for description in dimention.descriptions {
            descriptionString += description + " "
        }
        
        /// Show only last divider
        cell.dividerView.isHidden = true
        
        /// Update label
        cell.descriptionText = descriptionString
        
        return cell
    }
}
