//
//  QuickActionViewProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol QuickActionViewProtocol {
    
    /// Collection view
    var collectionView: UICollectionView { get set }
    
    /// Message
    var message: Message! { get set }
    
    /// Check if presented
    var isOpen: Bool { get set }
}

extension QuickActionViewProtocol {
    
    /// Generate Collection
    func generateCollection()-> UICollectionView {
        
        /// Layout
        let layout = CenterAlignedCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.clear
        
        return collectionView
    }
}
