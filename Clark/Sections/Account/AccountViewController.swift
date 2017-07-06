//
//  AccountViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    /// Tutor model
    var tutor: Tutor
    
    /// Collection View
    var collectionView: UICollectionView = {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = UIColor.white
        
        /// Register cells
        collectionView.register(AccountHeaderCollectionViewCell.self, forCellWithReuseIdentifier: "\(AccountHeaderCollectionViewCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Initialization
    init(tutor: Tutor) {
        self.tutor = tutor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Initial UI setup
        initialSetup()
        
        /// Back button
        setBackButton(image: #imageLiteral(resourceName: "back"))
    }
    
    // MARK: - Initial setup
    func initialSetup() {
        
        /// Navigation setup
        navigationController?.navigationBar.barTintColor = UIColor.dodgerBlue
        
        /// Collection view
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Background color
        view.backgroundColor = UIColor.white
        
        /// Collection View layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.bottom.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
        }
    }
}

// MARK: - CollectionView Delegate
extension AccountViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath)
    }
}

// MARK: - CollectionView Datasource
extension AccountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? .zero : UIEdgeInsets(top: 70, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - CollectionView Datasource
extension AccountViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(AccountHeaderCollectionViewCell.self)", for: indexPath) as! AccountHeaderCollectionViewCell
        
        cell.tutor = tutor
        
        return cell
    }
}
