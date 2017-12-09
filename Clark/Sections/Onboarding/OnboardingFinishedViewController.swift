//
//  OnboardingFinishedViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import CoreStore
import PromiseKit
import EZSwiftExtensions

enum OnboardingFinishedCells {
    
    case learningPlan
    case profile
    
    func generateTitle()-> String {
        switch self {
        case .learningPlan:
            return "Create learning plan"
        case .profile:
            return "Finish your profile"
        }
    }
    
    func generateDescription()-> String {
        switch self {
        case .learningPlan:
            return "Set expectations and introduce parents to Clark"
        case .profile:
            return "Publish your Clark business website to enable us to match you with new students in your area"
        }
    }
}

class OnboardingFinishedViewController: UIViewController {
    
    /// Datasource
    var datasource: [OnboardingFinishedCells] = [.learningPlan, .profile]

    /// Later button
    lazy var laterButton: UIButton = {
       
        let button = UIButton(type: .custom)
        button.adjustsImageWhenHighlighted = false
        button.setBackgroundColor(UIColor.white, forState: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Later", attributes: [NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 19), NSForegroundColorAttributeName: UIColor.trinidad]), for: .normal)
        
        return button
    }()
    
    /// Collection view
    lazy var collectionView: UICollectionView = {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        
        /// Register cells
        collectionView.register(TitleDescriptionHader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(TitleDescriptionHader.self)")
        collectionView.register(ActionDescriptionCell.self, forCellWithReuseIdentifier: "\(ActionDescriptionCell.self)")
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle("New Student")
        
        /// Inset setup
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        /// Custom init
        customInit()
    }
    
    func customInit() {
        
        /// Collection setup
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collectoin layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
        
        /// Later button
        view.addSubview(laterButton)
        laterButton.addTarget(self, action: #selector(onLaterButton(_:)), for: .touchUpInside)
        
        /// Later button layout
        laterButton.snp.updateConstraints { maker in
            maker.bottom.equalTo(self.view).offset(-24)
            maker.right.equalTo(self.view).offset(-24)
            maker.width.equalTo(110)
            maker.height.equalTo(50)
        }
        
        /// Later button
        laterButton.layer.borderWidth = 1.5
        laterButton.layer.cornerRadius = 4
        laterButton.layer.borderColor = UIColor.trinidad.cgColor
    }
    
    // MARK: - Actions
    func onCancelButton(_ sender: Any) {
        navigationController?.heroModalAnimationType = .cover(direction: .down)
        navigationController?.hero_dismissViewController()
    }
    
    // MARK: - Actions
    func onLaterButton(_ sender: UIButton) {
        dismissVC(completion: nil)
    }
}

// MARK: - CollectionView Datasource
extension OnboardingFinishedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        var cellHeight: CGFloat = 120
        
        /// Config
        let config = Config.shared
        
        /// Check if learning plan is enabled
        let type = datasource[indexPath.row]
        if type == .learningPlan {
            let learningPlanPermission = config.permissions?.learningPlans
            cellHeight = learningPlanPermission?.isEnabled == true ? 120 : 0
        }
        
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180)
    }
    
    /// Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            /// Header setup
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TitleDescriptionHader.self)", for: indexPath) as! TitleDescriptionHader
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 10
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "Welcome to Clark!", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            let paragraph2 = NSMutableParagraphStyle()
            paragraph2.lineSpacing = 5
            headerView.descriptionLabel.attributedText = NSAttributedString(string: "You're all set. Now let's keep building\nyour tutoring business.", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Delegate
extension OnboardingFinishedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        dismissVC(completion: nil)
        
        let type = datasource[indexPath.row]
        switch type {
        case .learningPlan:
            
            let _ = StudentAdapter.fetchList(include: .normal)
            ez.runThisAfterDelay(seconds: 0.5, after: { 
                
                let _ = StudentAdapter.fetchList().then { response-> Promise<[Session]> in
                    
                    return SessionAdapter.fetchList()
                }.then { response-> Void in
                    
                    /// Fetch student
                    guard let student = DatabaseManager.defaultStack.fetchOne(From<Student>()) else {
                        return
                    }
                    
                    print(student.sessionsArray)
                    
                    let createLearningPlanFlow = ClientsRouteHandler.createLearningPlanTransition(student: student)
                    
                    if let topController = AppDelegate.shared.window?.rootViewController {
                        topController.presentVC(createLearningPlanFlow.0)
                    }
                }
            })
            
        case .profile:
            print("send")
            UIApplication.shared.open(URL(string: "https://tutors.hiclark.com/start")!, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - CollectionView Datasource
extension OnboardingFinishedViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let type = datasource[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ActionDescriptionCell.self)", for: indexPath) as! ActionDescriptionCell
        
        cell.text = type.generateTitle()
        cell.descriptionText = type.generateDescription()
        
        cell.clipsToBounds = true
        
        return cell
    }
}

