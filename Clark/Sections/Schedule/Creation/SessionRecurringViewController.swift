//
//  SessionRecurringViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import SVProgressHUD
import EZSwiftExtensions

enum SessionRecurringCells {
    case recurring
    case reminder
    
    func titleCopy()-> String {
        switch self {
        case .recurring: return "Make this a recurring session"
        case .reminder: return "Send a text reminder 24 hours\nahead"
        }
    }
}

class SessionRecurringViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol {
    
    /// Title 
    var navigationTitle: String
    
    /// Student
    var student: Student?  {
        didSet {
            
            let name = student?.proxy != nil ? student?.proxy?.firstName : student?.firstName
            
            let copy = name != nil ? "to \(name ?? "")" : ""
            self.nameCopy = "Send a text reminder \(copy) 24 hours ahead"
            
            collectionView.reloadData()
        }
    }
    
    var nameCopy: String?

    /// On next
    var nextButtonSuccess: ((_ isRecurring: Bool, _ isReminder: Bool)->())?
    
    /// Is blocked
    var isNextBlocked = false
    
    /// Params
    var isRecurring: Bool = false
    var isReminder: Bool = false
    
    /// Popover view
    lazy var popover: Popover? = self.generatePopover()
    
    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// Help copy
    var helpCopy: String? {
        return "Reminders help students get to sessions on time, every time"
    }
    
    /// Right button
    lazy var rightButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onCancelButton(_:)))
        button.tintColor = UIColor.trinidad
        button.setTitleTextAttributes([NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 14)], for: .normal)
        
        return button
    }()
    
    /// Datasource
    var datasource: [SessionRecurringCells] = [.recurring, .reminder]
    
    /// Next Done button
    lazy var nextButton: UIButton? = self.generateDoneButton()
    
    /// Help button
    lazy var helpButton: UIButton? = self.generateHelpButton()
    
    /// Number of steps
    var currentStep: Int = 1
    var numberOfSteps: Int = 4
    
    /// First cell - for keyboard
    var firstNameCell: FormInputCell? = nil
    
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
        collectionView.register(SwitcherCell.self, forCellWithReuseIdentifier: "\(SwitcherCell.self)")
        collectionView.register(TitleDescriptionHader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(TitleDescriptionHader.self)")
        
        return collectionView
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
        Analytics.screen(screenId: .s20)
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
            self.firstNameCell?.formInput.becomeFirstResponder()
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

        if !isNextBlocked {
            nextButtonSuccess?(isRecurring,isReminder)
            isNextBlocked = true
        }
        
        ez.runThisAfterDelay(seconds: 2) {
            self.isNextBlocked = false
        }
    }
    
    func onHelpButton(_ sender: UIButton) {
        showPopoveView()
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping ((_ isRecurring: Bool, _ isReminder: Bool)->())) {
        nextButtonSuccess = completion
    }
    
    // MARK: - Actions
    func onCancelButton(_ sender: Any) {
        /// Dismiss
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
}

// MARK: - CollectionView Datasource
extension SessionRecurringViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        var cellHeight: CGFloat = 0
        
        /// Permissions check
        let config = Config.shared
        guard let permissions = config.permissions else {
            return CGSize(width: collectionView.frame.width, height: cellHeight)
        }
        
        /// Checking type & permissions
        switch datasource[indexPath.row] {
        case .recurring:
            cellHeight = permissions.automatedSessionBooking?.isEnabled == true ? 80 : 0
        case .reminder:
            cellHeight = permissions.sessionReminders?.isEnabled == true ? 110 : 0
        }

        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 120)
    }
    
    /// Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            /// Header setup
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TitleDescriptionHader.self)", for: indexPath) as! TitleDescriptionHader
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 10
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "Level up your session", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            let paragraph2 = NSMutableParagraphStyle()
            paragraph2.lineSpacing = 5
            headerView.descriptionLabel.attributedText = NSAttributedString(string: "Help your students get to each session with reminders!", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Datasource
extension SessionRecurringViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let switcherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SwitcherCell.self)", for: indexPath) as! SwitcherCell
        
        let type = datasource[indexPath.row]
        
        /// Number of lines
        if type == .reminder {
            switcherCell.simpleTitleLabel.numberOfLines = 2
            
            switcherCell.text = nameCopy ?? ""
        }
        else {
            switcherCell.text = type.titleCopy()
        }
        
        switcherCell.dividerLayout()
        switcherCell.delegate = self
        switcherCell.indexPath = indexPath
        switcherCell.clipsToBounds = true
        
        return switcherCell
    }
}

// MARK: - Switcher delegate
extension SessionRecurringViewController: SwitcherCellDelegate {
    func switcherChanged(_ switcher: UISwitch, indexPath: IndexPath) {
        
        let type = datasource[indexPath.row]
        switch type {
        case .recurring:
            isRecurring = switcher.isOn
        case .reminder:
            isReminder = switcher.isOn
        }
    }
}
