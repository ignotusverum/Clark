//
//  SessionStudentViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/31/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import CoreStore
import PromiseKit
import EZSwiftExtensions

class SessionStudentViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol, ListSectionObserver {
    
    /// Title
    var navigationTitle: String
    
    /// On next
    var nextButtonSuccess: ((Student)->())?
    
    /// Next Done button
    lazy var nextButton: UIButton? = self.generateNextButton()
    
    /// Help copy
    var helpCopy: String?
    
    /// Popover
    var popover: Popover?
    
    /// Help button
    var helpButton: UIButton?
    
    /// Search view
    lazy var searchView: SearchView = {
        
        let searchView = SearchView()
        searchView.backgroundColor = UIColor.lightTrinidad
        
        searchView.backgroundColor = UIColor.white
        
        searchView.searchIcon.tintColor = UIColor.black
        searchView.cancelButton.tintColor = UIColor.black
        searchView.searchTextField.textColor = UIColor.black
        searchView.searchTextField.tintColor = UIColor.trinidad
        
        searchView.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.gray, NSFontAttributeName: UIFont.defaultFont(size: 18)])
        
        return searchView
    }()

    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// List monitor
    lazy var studentsMonitor: ListMonitor<Student> = {
        return self.generateMonitor()
    }()
    
    /// Selected student
    var selectedStudent: Student?
    
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
        collectionView.register(SessionStudentCell.self, forCellWithReuseIdentifier: "\(SessionStudentCell.self)")
        collectionView.register(TitleAccessoryCell.self, forCellWithReuseIdentifier: "\(TitleAccessoryCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Init
    required init(currentStep: Int, numberOfSteps: Int, title: String) {
        
        self.navigationTitle = title
        
        self.currentStep = currentStep
        self.numberOfSteps = numberOfSteps
        
        super.init(nibName: nil, bundle: nil)
        
        /// Layout progress view
        layoutProgressView(step: currentStep, total: numberOfSteps)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Right button
        navigationItem.rightBarButtonItem = rightButton
        
        /// Controller setup
        controllerSetup()
        
        /// Fetch subjects
        SubjectAdapter.fetchForMe().then { response-> Promise<[Student]> in
            return StudentAdapter.fetchList()
            }.catch { error in
            print(error)
        }
        
        /// Track
        Analytics.screen(screenId: .s18)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Add observer
        studentsMonitor.addObserver(self)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

        /// Handle text did chage
        searchView.textDidChange({ text in
            self.searchTextChanged(text ?? "")
        })
        
        /// Clear button
        searchView.onClearButton({
            self.selectedStudent = nil
            self.searchTextChanged("")
            self.view.endEditing(true)
        })
        
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
        
        /// Title search
        view.addSubview(searchView)
        
        /// Search layout
        searchView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.height.equalTo(50)
        }
        
        /// Collectoin layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view).offset(50)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
        
        /// Next button layout
        nextLayout()
        
        /// Progress view layout
        layoutProgressView(step: currentStep, total: numberOfSteps)
        
        /// Add search border
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        border.frame = CGRect(x: 0, y: 48, width: view.size.width, height: 50)
        
        border.borderWidth = width
        searchView.layer.addSublayer(border)
        searchView.layer.masksToBounds = true
    }
    
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
    
    // MARK: - Utilities
    func generateMonitor()-> ListMonitor<Student> {
        
        return DatabaseManager.defaultStack.monitorList(From<Student>(),
                                                        OrderBy(.ascending(StudentAttributes.fullName.rawValue)))
    }
    
    /// Search handler
    ///
    /// - Parameter text: search name
    func searchTextChanged(_ text: String) {
        
        if text.length > 0 {
            
            let fullNameParams = "\(StudentAttributes.fullName.rawValue)"
            studentsMonitor.refetch(Where("\(fullNameParams) CONTAINS[c] %@", text), OrderBy(.ascending(StudentAttributes.fullName.rawValue)))
            
            return
        }
        
        /// Reset monitor
        studentsMonitor = generateMonitor()
        studentsMonitor.addObserver(self)
        collectionView.reloadData()
    }
    
    // MARK: ListObjectObserver
    func listMonitorDidChange(_ monitor: ListMonitor<Student>) {
        collectionView.reloadData()
    }
    
    func listMonitorDidRefetch(_ monitor: ListMonitor<Student>) {
        collectionView.reloadData()
    }
    
    /// Clear button
    func onClearButton() {
        self.searchTextChanged("")
        self.view.endEditing(true)
    }
    
    // MARK: - Actions
    func onNextButton(_ sender: UIButton) {
        
        guard let student = selectedStudent else {
            
            /// Show error
            BannerManager.manager.showBannerForErrorText("Whoops, please select contact", category: .all)
            
            return
        }
        
        /// Udpate params
        nextButtonSuccess?(student)
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping ((Student)->())){
        nextButtonSuccess = completion
    }
}

// MARK: - CollectionView Datasource
extension SessionStudentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
}

// MARK: - CollectionView Delegate
extension SessionStudentViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section < studentsMonitor.numberOfSections() {
        
            /// Get selected subject, update cell
            let cell = collectionView.cellForItem(at: indexPath) as! SessionStudentCell
            cell.isButtonSelected = !cell.isButtonSelected
            
            selectedStudent = cell.student
            collectionView.reloadData()
            
            return
        }
        
        /// Transition to create new student
        let createStudentFlow = CreateStudentFlow()
        createStudentFlow.needToShowFinal = false
        
        /// Callback to handle student creation
        createStudentFlow.onFlowCompleted { student in
            
            /// Safety check
            guard let student = student, let indexPath = self.studentsMonitor.indexPathOf(student) else {
                return
            }
            
            /// Selected student
            self.selectedStudent = student
            self.collectionView.reloadData()
            
            /// Scroll animation
            self.collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
        
        createStudentFlow.isModal = false
        
        createStudentFlow.numberOfSteps = 8
        createStudentFlow.currentStep += 1
        
        pushVC(createStudentFlow.nameVC)
    }
}

// MARK: - CollectionView Datasource
extension SessionStudentViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return studentsMonitor.numberOfSections() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return section < studentsMonitor.numberOfSections() ? studentsMonitor.numberOfObjectsInSection(section) : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        if indexPath.section < studentsMonitor.numberOfSections() {
            
            /// Student
            let student = studentsMonitor[indexPath]
            
            /// Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SessionStudentCell.self)", for: indexPath) as! SessionStudentCell
            
            cell.student = student
            cell.isButtonSelected = cell.student == selectedStudent
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleAccessoryCell.self)", for: indexPath) as! TitleAccessoryCell
        
        cell.text = "Add new student"
        
        return cell
    }
}
