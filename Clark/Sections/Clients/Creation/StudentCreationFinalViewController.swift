//
//  StudentCreationFinalViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/27/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import CoreStore
import PromiseKit
import EZSwiftExtensions

enum StudentFinishedCells {
    
    case learningPlan
    case session
    
    func generateTitle()-> String {
        switch self {
        case .learningPlan:
            return "Create learning plan"
        case .session:
            return "Schedule a session"
        }
    }
    
    func generateDescription()-> String {
        switch self {
        case .learningPlan:
            return "Set expectations and introduce parents to Clark"
        case .session:
            return "Add the session to your calendar to enable session reminders and payments"
        }
    }
}

class StudentCreationFinalViewController: UIViewController {
    
    /// Student
    var student: Student?
    
    /// Datasource
    var datasource: [StudentFinishedCells] = [.learningPlan, .session]
    
    /// On next
    var nextButtonSuccess: (()->())?
    
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
        
        /// Back icon
        setCustomBackButton(image: #imageLiteral(resourceName: "close_icon")) {
            self.dismissVC(completion: nil)
        }
        
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
    
    // MARK: - Scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Disable dismiss for small phones
        if UIDevice.current.screenType != .iPhone5 {
            view.endEditing(true)
        }
    }
    
    // MARK: - Actions
    func onLaterButton(_ sender: UIButton) {
        nextButtonSuccess?()
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping (()->())) {
        nextButtonSuccess = completion
    }
}

// MARK: - CollectionView Datasource
extension StudentCreationFinalViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        var cellHeight: CGFloat = 0
        
        /// Permissions check
        let config = Config.shared
        guard let permissions = config.permissions else {
            return CGSize(width: collectionView.frame.width, height: cellHeight)
        }
        
        /// Checking type & permissions
        switch datasource[indexPath.row] {
        case .learningPlan:
            cellHeight = permissions.learningPlans?.isEnabled == true ? 80 : 0
        case .session:
            cellHeight = permissions.sessionAdd?.isEnabled == true ? 110 : 0
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
            
            let name = student?.firstName ?? ""
            headerView.titleLabel.attributedText = NSAttributedString(string: "You’ve added \(name) to\nyour student list!", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            let paragraph2 = NSMutableParagraphStyle()
            paragraph2.lineSpacing = 5
            headerView.descriptionLabel.attributedText = NSAttributedString(string: "Tell us about your upcoming work with \(name)", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Delegate
extension StudentCreationFinalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        dismissVC(completion: nil)
        
        let type = datasource[indexPath.row]
        switch type {
        case .learningPlan:
            
            guard let student = student else {
                return
            }
            
            let createLearningPlanFlow = ClientsRouteHandler.createLearningPlanTransition(student: student)
            
            if let topController = AppDelegate.shared.window?.rootViewController {
                topController.presentVC(createLearningPlanFlow.0)
            }
            
            createLearningPlanFlow.1.onFlowCompleted({ learningPlan in
                /// Safety cehck
                guard let student = learningPlan?.student else {
                    return
                }
                
                /// Present student detail after learning plan created
                if let topController = AppDelegate.shared.window?.rootViewController {
                    
                    /// Fech latest student data + push
                    ClientsRouteHandler.clientTransition(student: student).then { response-> Void in
                        
                        /// Safety check
                        guard let response = response else {
                            return
                        }
                    
                        /// Present
                        topController.presentVC(response)
                        
                        ez.runThisAfterDelay(seconds: 0.5, after: {
                          
                            /// Scroll to learning plan
                            if let clientInfoVC = response.topViewController as? ClientsInfoViewController {
                                clientInfoVC.navigationView.tabSwitcherView.selectedType = .leaningPlan
                                clientInfoVC.navigationView.tabSwitcherView.updateSelection()
                                
                                /// Setup controller
                                clientInfoVC.pageVC.setViewControllers([clientInfoVC.controllers.last!], direction: .forward, animated: true, completion: nil)
                            }
                        })
                        
                        }.catch { error in
                            print(error)
                    }
                }
            })
            
        case .session:
            
            let createSessionFlow = ScheduleRouteHandler.createTransition(student: student)
            
            if let topController = AppDelegate.shared.window?.rootViewController {
                topController.presentVC(createSessionFlow)
            }
        }
        
        nextButtonSuccess?()
    }
}

// MARK: - CollectionView Datasource
extension StudentCreationFinalViewController: UICollectionViewDataSource {
    
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
