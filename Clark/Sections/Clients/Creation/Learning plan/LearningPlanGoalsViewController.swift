//
//  LearningPlanGoalsViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import EZSwiftExtensions

enum LearningPlanGoalsCells {
    case progress
}

class LearningPlanGoalsViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol {
    
    /// Student
    var student: Student!
    
    /// Title
    var navigationTitle: String
    
    /// On next
    var nextButtonSuccess: ((String)->())?
    
    /// Params
    var progress: String = ""
    
    /// Popover view
    lazy var popover: Popover? = self.generatePopover()
    
    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// Help copy
    var helpCopy: String? {
        return "These notes will be shared with students and parents"
    }
    
    /// Datasource
    var datasource: [LearningPlanGoalsCells] = [.progress]
    
    /// Next Done button
    lazy var nextButton: UIButton? = self.generateSkipButton()
    
    /// Help button
    lazy var helpButton: UIButton? = self.generateHelpButton()
    
    /// Number of steps
    var currentStep: Int = 1
    var numberOfSteps: Int = 4
    
    /// First cell - for keyboard
    var firstInputCell: FormInputCell? = nil
    
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
        collectionView.register(FormInputCell.self, forCellWithReuseIdentifier: "\(FormInputCell.self)")
        collectionView.register(ClientsTitleHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(ClientsTitleHeader.self)")
        
        return collectionView
    }()
    
    /// Right button
    lazy var rightButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onCancelButton(_:)))
        button.tintColor = UIColor.trinidad
        button.setTitleTextAttributes([NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 14)], for: .normal)
        
        return button
    }()
    
    // MARK: - Initialization
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
        
        /// Controller setup
        controllerSetup()
        
        /// Track
        Analytics.screen(screenId: .s26)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Right button
        navigationItem.rightBarButtonItem = rightButton
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        /// Next button action
        nextButton?.addTarget(self, action: #selector(onNextButton(_:)), for: .touchUpInside)
        
        /// Custom init
        customInit()
        
        /// Focusing first name
        ez.runThisAfterDelay(seconds: 1) {
            self.firstInputCell?.formInput.becomeFirstResponder()
        }
    }
    
    func customInit() {
        
        /// Collection setup
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Progress view layout
        layoutProgressView(step: currentStep, total: numberOfSteps)
        
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
        
        nextButtonSuccess?(progress)
    }
    
    func onHelpButton(_ sender: UIButton) {
        showPopoveView()
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping ((String)->())) {
        nextButtonSuccess = completion
    }
    
    // MARK: - Actions
    func onCancelButton(_ sender: Any) {
        /// Dismiss
        navigationController?.heroModalAnimationType = .cover(direction: .down)
        navigationController?.hero_dismissViewController()
    }
}

// MARK: - CollectionView Datasource
extension LearningPlanGoalsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        return CGSize(width: collectionView.frame.width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 120)
    }
    
    /// Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            /// Header setup
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(ClientsTitleHeader.self)", for: indexPath) as! ClientsTitleHeader
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 10
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "What are \(student.firstName ?? "")’s goals?", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Datasource
extension LearningPlanGoalsViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FormInputCell.self)", for: indexPath) as! FormInputCell
        
        inputCell.delegate = self
        inputCell.titleText = title
        inputCell.indexPath = indexPath
        inputCell.placeholder = "Describe what you, the student, and the parent want to accomplish. Be as specific as you can."
        inputCell.dividerView.isHidden = true
        
        firstInputCell = inputCell
        
        return inputCell
    }
}

// MARK: - Text Input delegate
extension LearningPlanGoalsViewController: FormInputCellDelegate {
    
    /// Return button pressed
    func textFieldHitReturn(_ textVies: UITextView, indexPath: IndexPath){
        onNextButton(nextButton!)
    }
    
    func textFieldDidChange(_ textView: UITextView, indexPath: IndexPath) {
        progress = textView.text
        
        if textView.text.length > 0 {
            
            nextButton?.setAttributedTitle(NSAttributedString(string: "Next", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 19)]), for: .normal)
            
            return
        }
        
        nextButton?.setAttributedTitle(NSAttributedString(string: "Skip", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 19)]), for: .normal)
    }
}
