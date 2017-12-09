//
//  SessionRateViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/31/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import Presentr
import FSCalendar
import PromiseKit
import EZSwiftExtensions

enum SessionRateCells {
    
    case rate
    case duration
    case date
    case time
}

class SessionRateViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol {
    
    /// Student
    var student: Student?
    
    /// Title
    var navigationTitle: String
    
    /// On next
    var nextButtonSuccess: ((_ rate: String, _ duration: String, _ date: Date, _ time: Date)->())?
    
    /// Params
    var rate: String?
    var duration: String?
    
    var date: Date?
    var time: Date?
    
    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// Popover setup
    lazy var popover: Popover? = self.generatePopover()
    
    /// Help copy
    var helpCopy: String? {
        return "This information will be shared with your student or their parent to confirm the session."
    }
    
    /// Datasource
    var datasource: [SessionRateCells] = [.rate, .duration, .date, .time]
    
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
        
        /// Controller setup
        controllerSetup()
        
        /// Right button
        navigationItem.rightBarButtonItem = rightButton
        
        /// Track
        Analytics.screen(screenId: .s19)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Custom init
        customInit()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        /// Show keyboard
        ez.runThisAfterDelay(seconds: 1) {
            self.rateInput?.becomeFirstResponder()
            
            /// Default values
            self.rate = self.student?.fee.toString
            self.duration = self.student?.defaultSessionLengthInMinutes?.stringValue
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
        
        guard let error = Validation.validateSessionRate(rate, duration: duration, day: date, time: time) else {
            
            nextButtonSuccess?(rate ?? "",duration ?? "",date ?? Date(),time ?? Date())
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
    func onNextButtonCallback(_ completion: @escaping ((_ rate: String, _ duration: String, _ date: Date, _ time: Date)->())){
        nextButtonSuccess = completion
    }
}

// MARK: - CollectionView Datasource
extension SessionRateViewController: UICollectionViewDelegateFlowLayout {
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
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "Add session details", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Delegate
extension SessionRateViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let type = datasource[indexPath.row]
        if type == .date {
         
            let calendarVC = CalendarViewController()
            calendarVC.delegate = self
            calendarVC.date = date ?? Date()
            customPresentViewController(calendarPresenter, viewController: calendarVC, animated: true, completion: nil)
        }
        else if type == .time {
            
            let timeVC = TimePickerViewController()
            timeVC.delegate = self
            
            customPresentViewController(timeSelectorPresenter, viewController: timeVC, animated: true, completion: nil)
        }
    }
}

// MARK: - CollectionView Datasource
extension SessionRateViewController: UICollectionViewDataSource {
    
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
        case .date:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DefaultTitleAccessoryCell.self)", for: indexPath) as! DefaultTitleAccessoryCell
            
            cell.titleText = "What day?"
            cell.placeholder = "Choose a day"
            
            /// Safety check
            if let date = date {
                cell.formInput.text = date.toString(format: "MMM d, yyyy")
            }
            
            return cell
        case .time:
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(DefaultTitleAccessoryCell.self)", for: indexPath) as! DefaultTitleAccessoryCell
            
            cell.titleText = "What time?"
            cell.placeholder = "Choose a time"
            cell.formInput.text = ""
            
            /// Safety check
            if let date = time {
                cell.formInput.text = date.toString(format: "h:mm a")
            }
            
            return cell
        }
    }
}

// MARK: - Input delegate
extension SessionRateViewController: FormInputCellDelegate {
    
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
extension SessionRateViewController: CalendarViewControllerProtocol {
    
    /// Called when date is selected
    func calendar(calendar: FSCalendar, dateSelected: Date) {
        /// Update date
        date = dateSelected
        
        /// Reload UI
        collectionView.reloadData()
        
        /// Animation delay
        ez.runThisAfterDelay(seconds: 0.2) {
            /// Dismiss
            self.dismissVC(completion: nil)
        }
    }
}

// MARK: - Time selection
extension SessionRateViewController: TimePickerViewControllerDelegate {
    
    /// Cancel pressed
    func timePickerOnCancel(_ picker: TimePickerViewController) {
        dismissVC(completion: nil)
    }
    
    /// Done pressed
    func timePickerOnDone(_ picker: TimePickerViewController, date: Date) {
        
        time = date
        
        dismissVC(completion: nil)
        collectionView.reloadData()
    }
}
