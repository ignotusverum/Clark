//
//  SessionReportNoteViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import EZSwiftExtensions

enum SessionReportNoteCells {
    case note
}

class SessionReportNoteViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol {
    
    /// Title
    var navigationTitle: String
    
    /// On next
    var nextButtonSuccess: ((String)->())?
    
    /// Params
    var note: String = ""
    
    /// Popover view
    lazy var popover: Popover? = self.generatePopover()
    
    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// Help copy
    var helpCopy: String? {
        return "Focus on the work you covered and any notable positives or negatives from the session itself"
    }
    
    /// Datasource
    var datasource: [SessionReportNoteCells] = [.note]
    
    /// Next Done button
    lazy var nextButton: UIButton? = self.generateNextButton()
    
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
        Analytics.screen(screenId: .s30)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Right button
        navigationItem.rightBarButtonItem = rightButton
        
        /// Next button action
        nextButton?.addTarget(self, action: #selector(onNextButton(_:)), for: .touchUpInside)
        
        /// Custom init
        customInit()
        
        /// Focusing first name
        ez.runThisAfterDelay(seconds: 1) {
            self.firstInputCell?.formInput.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
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
        
        guard note.length > 4 else {
            
            /// Show error
            BannerManager.manager.showBannerForErrorText("Whoops, please enter a valid note", category: .all)
            
            return
        }
        
        nextButtonSuccess?(note)
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
extension SessionReportNoteViewController: UICollectionViewDelegateFlowLayout {
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
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "What did you do during\nthe session?", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Datasource
extension SessionReportNoteViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FormInputCell.self)", for: indexPath) as! FormInputCell
        
        inputCell.isHiddenTitle = true
        inputCell.delegate = self
        inputCell.titleText = title
        inputCell.formInput.returnKeyType = .default
        inputCell.indexPath = indexPath
        inputCell.placeholder = "e.g. “We worked on the practice problem set and focused on topics the student had trouble with”"
        inputCell.dividerView.isHidden = true
        
        firstInputCell = inputCell
        
        return inputCell
    }
}

// MARK: - Text Input delegate
extension SessionReportNoteViewController: FormInputCellDelegate {
    
    /// Return button pressed
    func textFieldHitReturn(_ textVies: UITextView, indexPath: IndexPath){
        print("return")
    }
    
    func textFieldDidChange(_ textView: UITextView, indexPath: IndexPath) {
        note = textView.text
    }
}
