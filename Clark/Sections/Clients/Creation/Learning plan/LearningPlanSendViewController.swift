//
//  LearningPlanSendViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import CoreStore
import EZSwiftExtensions

enum LearningPlanSaveCells {
    
    case send
    case save
    
    func generateTitle()-> String {
        switch self {
        case .send:
            return "Send to parent/student"
        case .save:
            return "Save for later"
        }
    }
    
    func generateDescription()-> String {
        switch self {
        case .send:
            return "Start your engagement on the right foot by\nsharing your expectations"
        case .save:
            return "You can always send the learning plan at a later date"
        }
    }
}

class LearningPlanSendViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol {
    
    /// Title
    var navigationTitle: String
    
    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// On next
    var nextButtonSuccess: (()->())?
    
    /// Learning plan
    var learningPlan: LearningPlan?
    
    /// Datasource
    var datasource: [LearningPlanSaveCells] = [.send, .save]
    
    /// Popover setup
    lazy var popover: Popover? = nil
    
    /// Help copy
    var helpCopy: String? = nil
    
    /// Next Done button
    lazy var nextButton: UIButton? = nil
    
    /// Help button
    lazy var helpButton: UIButton? = nil
    
    /// Number of steps
    var currentStep: Int = 1
    var numberOfSteps: Int = 4
    
    /// Right button
    lazy var rightButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onCancelButton(_:)))
        button.tintColor = UIColor.trinidad
        button.setTitleTextAttributes([NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 14)], for: .normal)
        
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
        collectionView.register(ClientsTitleHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(ClientsTitleHeader.self)")
        collectionView.register(ActionDescriptionCell.self, forCellWithReuseIdentifier: "\(ActionDescriptionCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Initialization
    required init(currentStep: Int, numberOfSteps: Int, title: String) {
        
        self.navigationTitle = title
        
        self.currentStep = currentStep
        self.numberOfSteps = numberOfSteps
        
        super.init(nibName: nil, bundle: nil)
        
        /// Title
        setTitle(navigationTitle)
        
        /// Controller setup
        controllerSetup()
        
        /// Layout progress view
        layoutProgressView(step: currentStep, total: numberOfSteps)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("StudentSubjectViewController aDecoder not implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        controllerSetup()
        
        /// Right button
        navigationItem.rightBarButtonItem = rightButton
        
        /// Track
        Analytics.screen(screenId: .s28)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Title setup
        setTitle(navigationTitle)
        
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
    }
    
    // MARK: - Actions
    func onCancelButton(_ sender: Any) {
        nextButtonSuccess?()
        navigationController?.heroModalAnimationType = .cover(direction: .down)
        navigationController?.hero_dismissViewController()
        nextButtonSuccess?()
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping (()->())) {
        nextButtonSuccess = completion
    }
    
    // MARK: - Scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Disable dismiss for small phones
        if UIDevice.current.screenType != .iPhone5 {
            view.endEditing(true)
        }
    }
}

// MARK: - CollectionView Datasource
extension LearningPlanSendViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 130)
    }
    
    /// Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            
            /// Header setup
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ClientsTitleHeader.self)", for: indexPath) as! ClientsTitleHeader
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 10
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "Ready to send?", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Delegate
extension LearningPlanSendViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let type = datasource[indexPath.row]
        switch type {
        case .save:
            
            /// Dismiss
            dismissVC(completion: nil)
            nextButtonSuccess?()
            
        case .send:
            
            /// Send to client
            LearningPlanAdapter.sendToClient(learningPlan: learningPlan).then { response-> Void in
                
                self.dismissVC(completion: nil)
                self.nextButtonSuccess?()
                
                }.catch { error in
                    BannerManager.manager.showBannerForErrorText(error.localizedDescription, category: .all)
            }
        }
    }
}

// MARK: - CollectionView Datasource
extension LearningPlanSendViewController: UICollectionViewDataSource {
    
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
        
        return cell
    }
}
