//
//  LargeNavigationControllerProtocol.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol LargeNavigationControllerDelegate {
    /// Delegate call to parent controller to trigger transition
    ///
    /// - Parameter tabTitle: destination
    func switchTo(_ tabTitle: TabTitles)
}

protocol LargeNavigationControllerProtocol {
    
    /// Navigation view
    var navigationExtension: ExtendedNavBarView { get set }
    
    /// Collection view
    var collectionView: UICollectionView { get set }
    
    /// Delegate
    var delegate: LargeNavigationControllerDelegate? { get set }
    
    /// Navigation search text changed
    func searchTextChanged(_ text: String)
    
    /// Add button pressed
    func onAddButton()
    
    /// Clear button presssed
    func onClearButton()
}

extension LargeNavigationControllerProtocol where Self: UIViewController {
    
    /// Generate navigation view
    func generateNavigationView(title: String, image: UIImage)-> ExtendedNavBarView {
        
        let view = ExtendedNavBarView(title: title, style: .orange, type: .search, isRightButtonEnabled: true, image: image)
        
        /// Search  changes
        view.searchDidChange({ text in
            self.searchTextChanged(text ?? "")
        })
        
        /// Right button handler
        view.rightButtonPressed({
            self.onAddButton()
        })
        
        /// Clear button
        view.onClearButton({
            self.onClearButton()
        })
        
        return view
    }
    
    /// Generate collection view
    func generateCollectionView()-> UICollectionView {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionHeadersPinToVisibleBounds = true
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        
        /// Cells
        collectionView.register(ClientsCollectionViewCell.self, forCellWithReuseIdentifier: "\(ClientsCollectionViewCell.self)")
        
        return collectionView
    }
}
