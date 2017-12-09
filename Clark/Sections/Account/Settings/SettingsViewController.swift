//
//  SettingsViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/2/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    /// Tutor
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
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        
        /// Inset
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        /// Cell registration
        collectionView.register(SimpleTextCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(SimpleTextCollectionViewHeader.self)")
        collectionView.register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: "\(NotificationCollectionViewCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Init
    init(tutor: Tutor) {
        self.tutor = tutor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("SettingsViewController initCoder:")
    }
    
    // MARK: - Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Analytics
        Analytics.screen(screenId: .s10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.white
        
        /// Title
        setTitle("Settings")
        
        /// Back icon
        setCustomBackButton(image: #imageLiteral(resourceName: "back_icon")) {
            self.navigationController?.heroModalAnimationType = .slide(direction: .right)
            self.navigationController?.hero_dismissViewController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    // MARK: - Initial setup
    func initialSetup() {
        
        /// Collection view
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection view layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.bottom.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
        }
    }
}

// MARK: - CollectionView Delegate
extension SettingsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

// MARK: - CollectionView Datasource
extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
    
    /// Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            /// Header setup
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(SimpleTextCollectionViewHeader.self)", for: indexPath) as! SimpleTextCollectionViewHeader
            headerView.text = "Notifications"
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Datasource
extension SettingsViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(NotificationCollectionViewCell.self)", for: indexPath) as! NotificationCollectionViewCell
        
        /// Cell setup
        cell.tutor = tutor
        cell.delegate = self
        cell.text = "Enable Push Notifications ?"
        
        /// Hiding
        cell.dividerView.isHidden = true
        
        return cell
    }
}

// MARK: - Switcher delegate
extension SettingsViewController: NotificationCollectionViewCellDelegate {
    func switcherChangedTo(value: Bool) {
        
        /// Delegate call
        let updatedAttributes = [TutorJSON.pushNotificationsEnabled : value]
        
        /// Udpdate server object
        TutorAdapter.update(updatedAttributes).catch { error in
            print(error)
        }
    }
}
