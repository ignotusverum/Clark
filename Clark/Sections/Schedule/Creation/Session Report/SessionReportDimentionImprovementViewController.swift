//
//  SessionReportDimentionImprovementViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/12/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import CoreStore
import EZSwiftExtensions

class SessionReportDimentionImprovementViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol, ListSectionObserver {
    
    /// On next
    var nextButtonSuccess: ((_ dimentions: [ProgressDimention])->())?
    
    /// List monitor
    lazy var progressMonitor: ListMonitor<ProgressDimention> = {
        return DatabaseManager.defaultStack.monitorList(From<ProgressDimention>(),
                                                        OrderBy(.ascending(ProgressDimentionAttributes.name.rawValue)))
    }()
    
    /// Params
    var selectedDimentions: [ProgressDimention] = []
    
    /// Title
    var navigationTitle: String
    
    /// Selected dimentions
    var excludeDimentions: [ProgressDimention] = []
    
    /// Learning plan
    var learningPlan: LearningPlan?
    
    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// Popover setup
    lazy var popover: Popover? = nil
    
    /// Help copy
    var helpCopy: String? {
        return "You can choose more dimensions by editing the learning plan for this student"
    }
    
    /// Next Done button
    lazy var nextButton: UIButton? = self.generateNextButton()
    
    /// Help button
    lazy var helpButton: UIButton? = nil
    
    /// Number of steps
    var currentStep: Int = 1
    var numberOfSteps: Int = 4
    
    /// Right button
    lazy var rightButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onCancelButton(_:)))
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
        collectionView.register(TitleDescriptionHader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(TitleDescriptionHader.self)")
        collectionView.register(ProgressDimentionCell.self, forCellWithReuseIdentifier: "\(ProgressDimentionCell.self)")
        
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
        Analytics.screen(screenId: .s32)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Safety check
        guard let learningPlan = learningPlan else {
            return
        }
        
        /// Selected plan ids
        let exlucdeDimentionsIDs = excludeDimentions.map { $0.id }
        
        /// Refetch
        progressMonitor.refetch(Where("(\(ProgressDimentionRelationships.learningPlan.rawValue).\(ModelAttributes.id.rawValue) CONTAINS[c] %@) && NOT (ANY \(ModelAttributes.id.rawValue) IN %@)", learningPlan.id, exlucdeDimentionsIDs), OrderBy(.ascending(ProgressDimentionAttributes.name.rawValue)))
        
        /// Add observer
        progressMonitor.addObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Title setup
        setTitle(navigationTitle)
        
        /// Inset setup
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        /// Next button action
        nextButton?.addTarget(self, action: #selector(onNextButton(_:)), for: .touchUpInside)
        
        /// Custom init
        customInit()
    }
    
    func customInit() {
        
        /// Collection setup
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Buttons setup
        nextLayout()
        nextButton?.heroID = "nextButton"
        nextButton?.heroModifiers = [.cascade()]
        
        helpLayout()
        helpButton?.heroID = "helpButton"
        helpButton?.heroModifiers = [.cascade()]
        helpButton?.addTarget(self, action: #selector(onHelpButton(_:)), for: .touchUpInside)
        
        /// Collectoin layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
    }
    
    // MARK: - Actions
    func onNextButton(_ sender: UIButton) {
        guard selectedDimentions.count > 0 else {
            
            /// Show error
            BannerManager.manager.showBannerForErrorText("Whoops, please select at least 1 progress dimention", category: .all)
            
            return
        }
        
        nextButtonSuccess?(selectedDimentions)
    }
    
    func onHelpButton(_ sender: UIButton) {
        showPopoveView()
    }
    
    func onCancelButton(_ sender: Any) {
        navigationController?.heroModalAnimationType = .cover(direction: .down)
        navigationController?.hero_dismissViewController()
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping (([ProgressDimention])->())) {
        nextButtonSuccess = completion
    }
    
    // MARK: - Scroll view
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Disable dismiss for small phones
        if UIDevice.current.screenType != .iPhone5 {
            view.endEditing(true)
        }
    }
    
    // MARK: ListObjectObserver
    func listMonitorDidChange(_ monitor: ListMonitor<ProgressDimention>) {
        collectionView.reloadData()
    }
    
    func listMonitorDidRefetch(_ monitor: ListMonitor<ProgressDimention>) {
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Datasource
extension SessionReportDimentionImprovementViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        let dimention = progressMonitor[indexPath]
        return CGSize(width: collectionView.frame.width, height: ProgressDimentionCell.calculateHeight(dimention))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    /// Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            /// Header setup
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TitleDescriptionHader.self)", for: indexPath) as! TitleDescriptionHader
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 10
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "What needs\nimprovement?", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            let paragraph2 = NSMutableParagraphStyle()
            paragraph2.lineSpacing = 5
            headerView.descriptionLabel.attributedText = NSAttributedString(string: "Select all that apply", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Delegate
extension SessionReportDimentionImprovementViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ProgressDimentionCell
        
        /// Update selected dimentions
        if !selectedDimentions.contains(cell.dimention) {
            
            /// Add selected dimention
            selectedDimentions.append(cell.dimention)
            
            collectionView.reloadData()
            
            return
        }
        
        /// Remove selected dimention
        selectedDimentions.removeFirst(cell.dimention)
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Datasource
extension SessionReportDimentionImprovementViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return progressMonitor.numberOfObjects()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        /// Dimention
        let dimention = progressMonitor[indexPath]
        
        /// Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ProgressDimentionCell.self)", for: indexPath) as! ProgressDimentionCell
        
        /// Update cell
        cell.dimention = dimention
        
        /// Check if selected
        cell.isButtonSelected = selectedDimentions.contains(dimention)
        
        return cell
    }
}
