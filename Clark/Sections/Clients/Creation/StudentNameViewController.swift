//
//  StudentNameViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import EZSwiftExtensions

enum StudentNameCells {
    
    case firstName
    case lastName
    case age
}

class StudentNameViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol {

    /// Popover view
    lazy var popover: Popover? = self.generatePopover()

    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// On next
    var nextButtonSuccess: ((_ firstName: String, _ lastName: String, _ isUnder13: Bool)->())?
    
    /// Parameters
    var firstName: String?
    var lastName: String?
    
    var isUnder13: Bool = false
    
    /// Title
    var navigationTitle: String = ""
    
    /// Help copy
    var helpCopy: String? {
        return "We’ll never share information with anyone without your consent."
    }
    
    /// Datasource
    var datasource: [StudentNameCells] = [.firstName, .lastName, .age]
    
    /// Next Done button
    lazy var nextButton: UIButton? = self.generateNextButton()
    
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
        collectionView.register(FormInputCell.self, forCellWithReuseIdentifier: "\(FormInputCell.self)")
        collectionView.register(SwitcherCell.self, forCellWithReuseIdentifier: "\(SwitcherCell.self)")
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
        
        /// Layout progress view
        layoutProgressView(step: currentStep, total: numberOfSteps)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Update UI
        controllerSetup()
        
        /// Track
        Analytics.screen(screenId: .s13)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        view.endEditing(true)
        
        /// Safety check
        guard let error = Validation.validateName(first: firstName, last: lastName) else {

            /// Next button callback
            nextButtonSuccess?(firstName!, lastName!, isUnder13)
            
            return
        }
        
        /// Show error
        BannerManager.manager.showBannerForErrorText(error.copy(), category: .all)
    }
    
    func onHelpButton(_ sender: UIButton) {
        showPopoveView()
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping ((_ firstName: String, _ lastName: String, _ isUnder13: Bool)->())) {
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
extension StudentNameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        let height: CGFloat = datasource[indexPath.row] == .age ? 80 : 100
        return CGSize(width: collectionView.frame.width, height: height)
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
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "Who is this student?", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Datasource
extension StudentNameViewController: UICollectionViewDataSource {
    
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
        case .age:
            
            let switcherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(SwitcherCell.self)", for: indexPath) as! SwitcherCell
            
            switcherCell.delegate = self
            switcherCell.indexPath = indexPath
            switcherCell.text = "Under 13 years old?"
            
            return switcherCell
            
        default:
            
            let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FormInputCell.self)", for: indexPath) as! FormInputCell
            
            var title = ""
            switch type {
            case .firstName:
                title = "First name"
                firstNameCell = inputCell
            case .lastName:
                title = "Last name"
                inputCell.formInput.returnKeyType = .done
            default:
                print("not handled")
            }
            
            inputCell.delegate = self
            inputCell.titleText = title
            inputCell.indexPath = indexPath
            inputCell.placeholder = "e.g. Clark"
            
            return inputCell
        }
    }
}

// MARK: - Switcher delegate
extension StudentNameViewController: SwitcherCellDelegate {
    func switcherChanged(_ switcher: UISwitch, indexPath: IndexPath) {
        
        isUnder13 = switcher.isOn
    }
}

// MARK: - Text Input delegate
extension StudentNameViewController: FormInputCellDelegate {
    
    /// Return button pressed
    func textFieldHitReturn(_ textVies: UITextView, indexPath: IndexPath){
        
        let type = datasource[indexPath.row]
        if type == .lastName {
            onNextButton(nextButton!)
        }
    }
    
    func textFieldDidChange(_ textView: UITextView, indexPath: IndexPath) {
        
        /// Switch type & update
        let type = datasource[indexPath.row]
        switch type {
        case .firstName:
            firstName = textView.text
        case .lastName:
            lastName = textView.text
        default:
            print("Yo")
        }
    }
}
