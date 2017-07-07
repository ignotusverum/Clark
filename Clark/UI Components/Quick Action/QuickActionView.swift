//
//  QuickActionView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol QuickActionViewDelegate {
    /// Called when action selected
    func actionView(_ actionView: QuickActionView, selectedAction: QuickAction)
}

class QuickActionView: UIView {
    
    /// Message
    var message: Message {
        didSet {
            
            /// Hide view if no quick actions
            isHidden = message.quickActions.count == 0
        }
    }
    
    /// Delegate
    var delegate: QuickActionViewDelegate?
    
    /// Is open
    var isOpen: Bool = false
    
    /// Collection view
    lazy var collectionView: UICollectionView = {
       
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    // MARK: - Initialization
    init(message: Message) {
        self.message = message
        
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom setup
    private func customSetup() {
        
        /// Collection view
        addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - CollectionView Datasource
extension QuickActionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize.zero
    }
}

// MARK: - CollectionView Delegate
extension QuickActionView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

// MARK: - CollectionView Datasource
extension QuickActionView: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
