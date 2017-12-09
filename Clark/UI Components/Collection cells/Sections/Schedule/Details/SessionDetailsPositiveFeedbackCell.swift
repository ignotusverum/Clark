//
//  PositiveFeedbackCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/3/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

class SessionDetailsPositiveFeedbackCell: UICollectionViewCell, TitleCellProtocol, DividerCellProtocol, SessionFeedbackCellProtocol, SessionDetailsCellProtocol {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Title setup
            titleText = "What went well"
            
            /// Update layout
            layoutSubviews()
            
            collectionView.reloadData()
        }
    }
    
    /// Title text
    var titleText: String! {
        didSet {
            
            /// Title
            titleLabel.text = titleText
        }
    }
    
    /// Collection view
    lazy var collectionView: UICollectionView = self.generateCollectionView()
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Title label
    lazy var titleLabel: UILabel = self.generateTitleLabel()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider setup
        dividerLayout()
        
        /// Title setup
        titleLabelLayout()
        
        /// Collection view setup
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(FeedbackTypeCell.self, forCellWithReuseIdentifier: "\(FeedbackTypeCell.self)")
        
        /// Collection view layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(titleLabel.bottom + 13)
            maker.bottom.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
    }
    
    /// Calculated height
    class func calculatedHeight(session: Session)-> CGFloat {
        let number = session.sessionReport?.dimentions.count ?? 0
        
        var spacing: CGFloat = number > 0 ? 24 : 0
        spacing = number == 1 ? 34 : spacing
        
        let size: CGFloat = CGFloat(number * 70) + spacing
        return size
    }
}

// MARK: - CollectionView Datasource
extension SessionDetailsPositiveFeedbackCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

// MARK: - CollectionView Datasource
extension SessionDetailsPositiveFeedbackCell: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return session.sessionReport?.dimentions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FeedbackTypeCell.self)", for: indexPath) as! FeedbackTypeCell
        
        let dimention = session.sessionReport!.dimentions[indexPath.row]
        
        cell.type = .positive
        cell.clipsToBounds = true
        cell.feedbackString = dimention.name ?? ""
        
        return cell
    }
}
