//
//  StudentSubjectViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/28/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import CoreStore
import EZSwiftExtensions

class StudentSubjectViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol, ListSectionObserver {
    
    /// On next
    var nextButtonSuccess: ((Subject) -> ())?
    
    /// Params
    var selectedSubject: Subject?

    /// Title
    var navigationTitle: String
    
    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// Popover setup
    lazy var popover: Popover? = nil
    
    /// Block next button
    var blockNext: Bool = false
    
    /// Help copy
    var helpCopy: String? = nil
    
    /// Subjects list
    lazy var subjectMonitor: ListMonitor<Subject> = {
        
        let config = Config.shared
        let tutor = config.currentTutor!
        
        /// Preticate
        let preticate = "\(SubjectRelationships.tutor.rawValue).\(ModelAttributes.id.rawValue) == %@"
        
        /// Fetch subjects for current tutor
        return DatabaseManager.defaultStack.monitorList(From<Subject>(),
                                                        Where(preticate, tutor.id),
                                                        OrderBy(.ascending(SubjectAttributes.name.rawValue)))
    }()
    
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
        collectionView.register(SubjectSelectionCell.self, forCellWithReuseIdentifier: "\(SubjectSelectionCell.self)")
        collectionView.register(TitleDetailsCell.self, forCellWithReuseIdentifier: "\(TitleDetailsCell.self)")
        collectionView.register(ClientsTitleHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(ClientsTitleHeader.self)")
        
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
        
        /// Fetch subjects
        SubjectAdapter.fetchForMe().catch { error in
            print(error)
        }
        
        /// Track
        Analytics.screen(screenId: .s16)
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
        
        /// Observer
        subjectMonitor.addObserver(self)
        
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
    
    // MARK: ListObjectObserver
    func listMonitorDidChange(_ monitor: ListMonitor<Subject>) {
        collectionView.reloadData()
    }
    
    func listMonitorDidRefetch(_ monitor: ListMonitor<Subject>) {
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    func onNextButton(_ sender: UIButton) {
        
        guard let error = Validation.validateContactSubject(selectedSubject) else {

            if !blockNext {
                nextButtonSuccess?(selectedSubject!)
                
                blockNext = true
            }
            
            ez.runThisAfterDelay(seconds: 1) {
                self.blockNext = false
            }
            
            return
        }
        
        /// Show error
        BannerManager.manager.showBannerForErrorText(error.copy(), category: .all)
    }
    
    func onHelpButton(_ sender: UIButton) {
        showPopoveView()
    }
    
    func onCancelButton(_ sender: Any) {
        navigationController?.heroModalAnimationType = .cover(direction: .down)
        navigationController?.hero_dismissViewController()
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping ((Subject)->())) {
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
extension StudentSubjectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var height: CGFloat = subjectMonitor.sections().count > 0 && section == 0 ? 130 : 0
        if subjectMonitor.sections().count == 0 && section == 0 {
            height = 130
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
    
    /// Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            /// Header setup
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ClientsTitleHeader.self)", for: indexPath) as! ClientsTitleHeader
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 10
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "What are you going to\nteach?", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Delegate
extension StudentSubjectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section < subjectMonitor.numberOfSections() {
            
            /// Update cell state
            let cell = collectionView.cellForItem(at: indexPath) as! SubjectSelectionCell
            cell.isButtonSelected = !cell.isButtonSelected
            
            /// Update request params
            selectedSubject = cell.isButtonSelected ? cell.subject : nil
            
            /// Reload data
            collectionView.reloadData()
            
            return
        }
        
        /// Selection segue
        let subjectsListVC = StudentSubjectsListViewController()
        pushVC(subjectsListVC)
    }
}

// MARK: - CollectionView Datasource
extension StudentSubjectViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return subjectMonitor.numberOfSections() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return section < subjectMonitor.numberOfSections() ? subjectMonitor.numberOfObjectsInSection(section) : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        if indexPath.section < subjectMonitor.numberOfSections() {
        
            let subject = subjectMonitor[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SubjectSelectionCell.self)", for: indexPath) as! SubjectSelectionCell
            
            cell.subject = subject
            cell.isButtonSelected = subject == selectedSubject
            cell.dividerView.isHidden = indexPath.row == subjectMonitor.numberOfObjects()
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleDetailsCell.self)", for: indexPath) as! TitleDetailsCell
        
        cell.text = "No subjects"
        cell.descriptionText = subjectMonitor.numberOfObjects() > 0 ? "Add Subject" : "Add"
        cell.dividerView.isHidden = true
        
        return cell
    }
}
