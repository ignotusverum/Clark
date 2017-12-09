//
//  FeedbackCellProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/3/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Foundation

protocol SessionFeedbackCellProtocol {
    
    /// Session 
    var session: Session! { get set }
    
    /// Collectoin view
    var collectionView: UICollectionView { get set }
}

extension SessionFeedbackCellProtocol where Self: UICollectionViewCell {
    
    /// Generate collectionView
    func generateCollectionView()-> UICollectionView {
     
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
    }
}
