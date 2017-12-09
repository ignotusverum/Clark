//
//  LearningPlanRateViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import Presentr
import FSCalendar
import PromiseKit
import SVProgressHUD
import EZSwiftExtensions

enum LearningPlanRateCells {
    
    case rate
    case duration
    case frequency
    case endDate
}

enum FrequencyType: String {
    
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

class LearningPlanRateViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol {
    
    /// Student
    var student: Student? {
        didSet {
            
            /// Default values
            rate = student?.fee.toString
            duration = student?.defaultSessionLengthInMinutes?.stringValue
            
            /// Reload
            collectionView.reloadData()
        }
    }
    
    /// Title
    var navigationTitle: String
    
    /// On next
    var nextButtonSuccess: ((_ rate: String, _ duration: String, _ frequency: String, _ endDate: Date?)->())?
    
    /// Block next button
    var blockNext: Bool = false
    
    /// Params
    var rate: String?
    var duration: String?
    
    var frequency: FrequencyType = .weekly
    var endDate: Date?
    
    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// Popover setup
    lazy var popover: Popover? = self.generatePopover()
    
    /// Help copy
    var helpCopy: String? {
        return "Don't worry if not all sessions are alike - you can edit details on a per-session basis."
    }
    
    /// Datasource
    var datasource: [LearningPlanRateCells] = [.rate, .duration, .frequency, .endDate]
    
    /// Frequency datesource
    var frequencyDatasource: [FrequencyType] = [.daily, .weekly, .monthly]
    
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
    
    /// Modal presented
    let calendarPresenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.dismissOnSwipe = true
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.dismissAnimated = true
        
        return presenter
    }()
    
    let timeSelectorPresenter: Presentr = {
        
        let width = ModalSize.custom(size: 300)
        let height = ModalSize.custom(size: 300)
        let center = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = nil
        customPresenter.roundCorners = true
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        return customPresenter
    }()
    
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
        collectionView.register(SuffixInputCell.self, forCellWithReuseIdentifier: "\(SuffixInputCell.self)")
        collectionView.register(PrefixInputCell.self, forCellWithReuseIdentifier: "\(PrefixInputCell.self)")
        collectionView.register(TitleTextCell.self, forCellWithReuseIdentifier: "\(TitleTextCell.self)")
        collectionView.register(DefaultTitleAccessoryCell.self, forCellWithReuseIdentifier: "\(DefaultTitleAccessoryCell.self)")
        collectionView.register(ClientsTitleHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(ClientsTitleHeader.self)")
        
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
        
        SVProgressHUD.dismiss()
        
        /// Controller setup
        controllerSetup()
        
        /// Update
        collectionView.reloadData()
        
        /// Right button
        navigationItem.rightBarButtonItem = rightButton
        
        /// Track
        Analytics.screen(screenId: .s24)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Custom init
        customInit()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
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
        nextButton?.addTarget(self, action: #selector(onNextButton(_:)), for: .touchUpInside)
        
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
        
        /// Buttons layout
        helpLayout()
        nextLayout()
    }
    
    // MARK: - Actions
    func onNextButton(_ sender: UIButton) {
        guard let error = Validation.validateLearningPlanRate(rate, duration: duration, frequency: frequency.rawValue) else {
            
            if !blockNext {
                nextButtonSuccess?(rate ?? "", duration ?? "", frequency.rawValue, endDate)
                
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
    func onNextButtonCallback(_ completion: @escaping ((_ rate: String, _ duration: String, _ frequency: String, _ endDate: Date?)->())){
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
extension LearningPlanRateViewController: UICollectionViewDelegateFlowLayout {
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
            
            guard let name = student!.firstName else {
                return headerView
            }
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "Tell us more about your sessions \(name)", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Delegate
extension LearningPlanRateViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// End editing
        view.endEditing(true)
        
        let type = datasource[indexPath.row]
        if type == .endDate {
            
            let calendarVC = CalendarViewController()
            calendarVC.delegate = self
            calendarVC.date = endDate ?? Date()
            customPresentViewController(calendarPresenter, viewController: calendarVC, animated: true, completion: nil)
        }
        else if type == .frequency {
            
            /// Present alert selector
            let selectionVC = UIAlertController(title: "Frequency", message: nil, preferredStyle: .actionSheet)
            
            selectionVC.view.tintColor = UIColor.trinidad
            
            for frequency in frequencyDatasource {
                
                /// Mobile alert
                let alert = UIAlertAction(title: frequency.rawValue, style: .default, handler: { mobileType in
                    self.frequency = frequency
                    self.collectionView.reloadData()
                })
                
                selectionVC.addAction(alert)
            }
            
            /// Cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            /// Actions
            selectionVC.addAction(cancelAction)
            
            /// Present alert
            presentVC(selectionVC)
        }
    }
}

// MARK: - CollectionView Datasource
extension LearningPlanRateViewController: UICollectionViewDataSource {
    
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
            inputCell.placeholder = "150"
            inputCell.delegate = self
            inputCell.indexPath = indexPath
            inputCell.titleText = "Hourly rate"
            inputCell.formInput.keyboardType = .numberPad
            
            inputCell.formInput.returnKeyType = .next
            inputCell.formInput.text = rate == nil ? student?.fee.toString : rate
            
            rateInput = inputCell.formInput
            
            return inputCell
        case .duration:
            
            let durationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SuffixInputCell.self)", for: indexPath) as! SuffixInputCell
            
            durationCell.delegate = self
            durationCell.indexPath = indexPath
            durationCell.suffixText = "minutes"
            
            durationCell.titleText = "Session Duration"
            durationCell.formInput.text = duration == nil ? student?.defaultSessionLengthInMinutes?.stringValue : duration
            durationCell.placeholder = durationCopy
            
            durationCell.formInput.keyboardType = .numberPad
            
            return durationCell
        case .endDate:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DefaultTitleAccessoryCell.self)", for: indexPath) as! DefaultTitleAccessoryCell
            
            cell.titleText = "Engagement end date (optional)"
            cell.placeholder = Date().monthAsString
            
            /// Safety check
            if let date = endDate {
                cell.formInput.text = date.toString(format: "MMM d, yyyy")
            }
            
            return cell
        case .frequency:
            
            let frequencyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleTextCell.self)", for: indexPath) as! TitleTextCell
            
            frequencyCell.text = frequency.rawValue
            frequencyCell.titleText = "Frequency"
            
            return frequencyCell
        }
    }
}

// MARK: - Input delegate
extension LearningPlanRateViewController: FormInputCellDelegate {
    
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
        default:
            print("YO")
        }
    }
}

// MARK: - Calendar selection
extension LearningPlanRateViewController: CalendarViewControllerProtocol {
    
    /// Called when date is selected
    func calendar(calendar: FSCalendar, dateSelected: Date) {
        /// Update date
        endDate = dateSelected
        
        /// Reload UI
        collectionView.reloadData()
        
        /// Animation delay
        ez.runThisAfterDelay(seconds: 0.2) {
            /// Dismiss
            self.dismissVC(completion: nil)
        }
    }
}
