//
//  StudentRateViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/28/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import PromiseKit
import EZSwiftExtensions

enum StudentRateCells {
    
    case rate
    case duration
}

class StudentRateViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol {
    
    /// Title
    var navigationTitle: String
    
    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// On next
    var nextButtonSuccess: ((_ rate: String, _ duration: String)->())?
    
    /// Params
    var rate: String?
    var duration: String?
    
    /// Popover setup
    lazy var popover: Popover? = self.generatePopover()
    
    /// Help copy
    var helpCopy: String? {
        return "Don’t worry if not all sessions are alike - you can change any of these details on a per-session basis."
    }
    
    /// Datasource
    var datasource: [StudentRateCells] = [.rate, .duration]
    
    /// Next Done button
    lazy var nextButton: UIButton? = self.generateNextButton()
    
    /// Help button
    lazy var helpButton: UIButton? = self.generateHelpButton()
    
    /// Duration
    var durationCopy = "60"
    
    /// Keyboard text
    var rateInput: UITextView?
    
    /// Number of steps
    var currentStep: Int = 4
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
        
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        
        /// Register cells
        collectionView.register(SuffixInputCell.self, forCellWithReuseIdentifier: "\(SuffixInputCell.self)")
        collectionView.register(PrefixInputCell.self, forCellWithReuseIdentifier: "\(PrefixInputCell.self)")
        collectionView.register(ClientsTitleHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(ClientsTitleHeader.self)")
        
        return collectionView
    }()
    
    // MARK: - Initialization
    required init(currentStep: Int, numberOfSteps: Int, title: String) {
        
        self.navigationTitle = title
        
        self.currentStep = currentStep
        self.numberOfSteps = numberOfSteps
        
        super.init(nibName: nil, bundle: nil)
        
        /// Title setup
        setTitle(navigationTitle)
        
        /// Controller setup
        controllerSetup()
        
        /// Layout progress view
        layoutProgressView(step: currentStep, total: numberOfSteps)
        
        /// Update buttons
        if currentStep != numberOfSteps {
            nextButton = generateNextButton()
        }
        else {
            nextButton = generateDoneButton()
        }
        
        /// Next button action
        nextButton?.addTarget(self, action: #selector(onNextButton(_:)), for: .touchUpInside)
        nextLayout()
        helpLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("StudentRateViewController aDecoder not implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        controllerSetup()
        
        /// Right button
        navigationItem.rightBarButtonItem = rightButton
        
        /// Track
        Analytics.screen(screenId: .s17)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Custom init
        customInit()
        
        /// Show keyboard
        ez.runThisAfterDelay(seconds: 1) {
            self.rateInput?.becomeFirstResponder()
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
        
        /// Buttons setup
        nextButton?.heroID = "nextButton"
        nextButton?.heroModifiers = [.cascade()]
        
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
        
        /// Duration update
        duration = durationCopy
        
        /// Hide keyboard
        view.endEditing(true)
        
        /// Safety check
        guard (rate ?? "").length > 0 else {
            
            /// Show error
            BannerManager.manager.showBannerForErrorText(CreateError.rate.copy(), category: .all)
            return
        }
        
        guard (duration ?? "").length > 0 else {
            
            /// Show error
            BannerManager.manager.showBannerForErrorText(CreateError.duration.copy(), category: .all)
            return
        }
        
        nextButtonSuccess?(duration!, rate!)
    }
    
    func onHelpButton(_ sender: UIButton) {
        showPopoveView()
    }
    
    func onCancelButton(_ sender: Any) {
        navigationController?.heroModalAnimationType = .cover(direction: .down)
        navigationController?.hero_dismissViewController()
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping ((_ duration: String, _ rate: String)->())) {
        nextButtonSuccess = completion
    }
}

// MARK: - CollectionView Datasource
extension StudentRateViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 100)
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
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "How much do you\ncharge per session?", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Datasource
extension StudentRateViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let type = datasource[indexPath.row]
        switch type {
        case .rate:
            let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PrefixInputCell.self)", for: indexPath) as! PrefixInputCell
            
            inputCell.prefixText = "$"
            inputCell.delegate = self
            inputCell.placeholder = "150"
            inputCell.indexPath = indexPath
            inputCell.titleText = "Hourly rate"
            inputCell.formInput.keyboardType = .numberPad
            
            inputCell.formInput.returnKeyType = .next
            inputCell.formInput.text = rate
            
            rateInput = inputCell.formInput
            
            return inputCell
        case .duration:
            
            let durationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SuffixInputCell.self)", for: indexPath) as! SuffixInputCell
            
            durationCell.formInput.text = duration
            
            durationCell.delegate = self
            durationCell.indexPath = indexPath
            durationCell.suffixText = "minutes"
            durationCell.placeholder = durationCopy
            durationCell.titleText = "Session Duration"
            durationCell.formInput.keyboardType = .numberPad
            
            return durationCell
        }
    }
}

extension StudentRateViewController: FormInputCellDelegate {
    
    /// Return button pressed
    func textFieldHitReturn(_ textVies: UITextView, indexPath: IndexPath){
        
        let type = datasource[indexPath.row]
        if type == .duration {
            onNextButton(nextButton!)
        }
    }
    
    /// Text field did change
    func textFieldDidChange(_ textView: UITextView, indexPath: IndexPath){
     
        let type = datasource[indexPath.row]
        switch type {
        case .duration:
            duration = textView.text
        case .rate:
            rate = textView.text
        }
    }
}
