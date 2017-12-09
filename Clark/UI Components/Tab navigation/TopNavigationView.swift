//
//  TopNavigationView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol TopNavigationViewDelegate {
    
    /// Called when tab selected
    func onTab(_ selectedType: TopNavigationDatasourceType)
}

enum TopNavigationDatasourceType: String {
    case sessions = "Sessions"
    case details = "Details"
    case leaningPlan = "Learning Plan"
}

class TopNavigationView: UIView {
    
    /// Student
    var student: Student
    
    /// Datasource
    var datasource: [TopNavigationDatasourceType] = []
    
    /// Delegate
    var delegate: TopNavigationViewDelegate?
    
    /// Selected type
    var selectedType: TopNavigationDatasourceType = .details {
        didSet {
            
            delegate?.onTab(selectedType)
        }
    }
    
    /// Selection view
    lazy var selectionView: UIView = {
       
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.66)
        
        return view
    }()
    
    /// Collection View
    var collectionView: UICollectionView = {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.alwaysBounceHorizontal = true
        collectionView.backgroundColor = UIColor.white
        
        /// Cell registration
        collectionView.register(TabNavigationCell.self, forCellWithReuseIdentifier: "\(TabNavigationCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Initialization
    init (student: Student) {
        self.student = student
        super.init(frame: .zero)
        
        /// Datasource setup
        datasourceSetup()
        
        /// Custom init
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("TopNavigationView not implemented aDecoder")
    }
    
    // MARK: - Custom init
    func datasourceSetup() {
        
        datasource = []
        
        /// Permissions check
        let config = Config.shared
        if let sessionsPermissions = config.permissions?.sessionAdd, sessionsPermissions.isEnabled == true {
            
            /// Always show sessions
            datasource.append(.sessions)
            selectedType = .sessions
        }
        else {
            
            /// If there's a session, show list
            if student.sessionsArray.count > 0 {
                /// Always show sessions
                datasource.append(.sessions)
                selectedType = .sessions
            }
            else {
                /// Change selected type
                selectedType = .details
            }
        }
        
        /// Always show details
        datasource.append(.details)
        
        if student.learningPlanArray.count > 0 {
            /// Always show leaning plans
            datasource.append(.leaningPlan)
        }
    }
    
    private func customInit() {
        
        /// Color
        collectionView.backgroundColor = UIColor.clear
        
        /// Collection view
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection view layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self)
            maker.bottom.equalTo(self)
            maker.left.equalTo(self)
            maker.right.equalTo(self)
        }
        
        /// Selection view
        addSubview(selectionView)
        
        /// Slection view layout
        updateSelection()
    }
    
    // MARK: - Utilities
    func updateSelection(scrollingPosition: CGFloat = 0.0) {
        
        /// Current width
        let width = TabNavigationCell.widthCalculation(type: selectedType)
        
        /// Left position
        var leftPosition: CGFloat = 16
        
        /// User for touch event
        if scrollingPosition == 0.0 {
        
            /// Current index
            let currentIndex = datasource.index(of: selectedType) ?? 0
            for (i, type) in datasource.enumerated() {
                if currentIndex - 1 >= 0 && i != currentIndex && currentIndex > i {
                 
                    leftPosition += 16 + TabNavigationCell.widthCalculation(type: type)
                }
            }
        }
        else {
            /// Scrolling position - scroll view delegate
            leftPosition = scrollingPosition + 16
        }
        
        /// Animation
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseIn
            , animations: { 
                
                /// Selection view layout
                self.selectionView.snp.updateConstraints { maker in
                    maker.left.equalTo(leftPosition)
                    maker.width.equalTo(width)
                    maker.bottom.equalTo(self)
                    maker.height.equalTo(3)
                }
                
                self.layoutSubviews()
        }, completion: nil)
    }
}

// MARK: - CollectionView Datasource
extension TopNavigationView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        let type = datasource[indexPath.row]
        let width = TabNavigationCell.widthCalculation(type: type)
        
        return CGSize(width: width, height: collectionView.frame.height)
    }
}

// MARK: - CollectionView Delegate
extension TopNavigationView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// Update selection view
        let type = datasource[indexPath.row]
        selectedType = type
        updateSelection()
    }
}

// MARK: - CollectionView Datasource
extension TopNavigationView: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TabNavigationCell.self)", for: indexPath) as! TabNavigationCell

        let type = datasource[indexPath.row]
        cell.type = type
        
        return cell
    }
}
