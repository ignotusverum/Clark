//
//  StudentContactViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import EZSwiftExtensions

enum StudentContactType: String {
    
    case mobile = "mobile"
    case email
}

enum StudentContactCells {
    
    case type
    case entry
}

class StudentContactViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol {

    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// Popover setup
    lazy var popover: Popover? = self.generatePopover()

    /// Help copy
    var helpCopy: String? {
        return "We’ll never contact your clients without checking with you first"
    }
    
    /// Title
    var navigationTitle: String
    
    /// Country input
    var countryInput: CountryInput?
    
    /// On next
    var nextButtonSuccess: ((_ email: String, _ phoneNumber: String)->())?
    
    /// Datasource
    var typeContact: StudentContactType = .mobile
    var datasource: [StudentContactCells] = [.type, .entry]
    
    /// Number of steps
    var currentStep: Int = 1
    var numberOfSteps: Int = 4
    
    /// Next Done button
    lazy var nextButton: UIButton? = self.generateNextButton()
    
    /// Help button
    lazy var helpButton: UIButton? = self.generateHelpButton()
    
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
        collectionView.register(TitleTextCell.self, forCellWithReuseIdentifier: "\(TitleTextCell.self)")
        collectionView.register(FormInputCell.self, forCellWithReuseIdentifier: "\(FormInputCell.self)")
        collectionView.register(PhoneInputCell.self, forCellWithReuseIdentifier: "\(PhoneInputCell.self)")
        collectionView.register(ClientsTitleHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(ClientsTitleHeader.self)")
        
        return collectionView
    }()
    
    /// Contact cell - keyboard
    var phoneInputCell: PhoneInputCell?
    
    /// Right button
    lazy var rightButton: UIBarButtonItem = {
        
        let button = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(onCancelButton(_:)))
        button.tintColor = UIColor.trinidad
        button.setTitleTextAttributes([NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 14)], for: .normal)
        
        return button
    }()
    
    /// Validation
    var phone: String?
    var email: String?
    var countryCode: String = "US"
    
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
        fatalError("StudentContactViewController aDecoder not implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Buttons setup
        helpLayout()
        nextLayout()
        
        /// Controller setup
        controllerSetup()
        
        /// Right button
        navigationItem.rightBarButtonItem = rightButton
        
        nextButton?.heroID = "nextButton"
        nextButton?.heroModifiers = [.cascade()]
        
        helpButton?.heroID = "helpButton"
        helpButton?.heroModifiers = [.cascade()]
        
        helpButton?.addTarget(self, action: #selector(onHelpButton(_:)), for: .touchUpInside)
        
        /// Track
        Analytics.screen(screenId: .s14)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Next button action
        nextButton?.addTarget(self, action: #selector(onNextButton(_:)), for: .touchUpInside)
        
        /// Custom init
        customInit()
        
        /// Show keyboard
        ez.runThisAfterDelay(seconds: 1) {
            self.phoneInputCell?.textField.becomeFirstResponder()
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
        
        /// Collectoin layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
    }
    
    // MARK: - Actions
    func onCancelButton(_ sender: Any) {
        /// Dismiss
        navigationController?.heroModalAnimationType = .cover(direction: .down)
        navigationController?.hero_dismissViewController()
    }
    
    func onHelpButton(_ sender: UIButton) {
        showPopoveView()
    }
    
    func onNextButton(_ sender: UIButton) {
        
        view.endEditing(true)
        
        /// Safety check
        let entry = typeContact == .mobile ? phone : email
        guard let error = Validation.validateContactType(type: typeContact, entry: entry, country: countryCode) else {

            nextButtonSuccess?(email ?? "", phone ?? "")
            
            return
        }
        
        /// Show error
        BannerManager.manager.showBannerForErrorText(error.copy(), category: .all)
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping ((_ email: String, _ phoneNumber: String)->())) {
        nextButtonSuccess = completion
    }
    
    // MARK: - Scrolling setup
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        countryInput?.dismissPicker(true)
        
        /// Disable dismiss for small phones
        if UIDevice.current.screenType != .iPhone5 {
            view.endEditing(true)
        }
    }
}

// MARK: - CollectionView Datasource
extension StudentContactViewController: UICollectionViewDelegateFlowLayout {
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
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "How do we contact the\nstudent?", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Delegate
extension StudentContactViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
         
            /// Present alert selector
            let selectionVC = UIAlertController(title: "Contact preference", message: nil, preferredStyle: .actionSheet)
            
            selectionVC.view.tintColor = UIColor.trinidad
            
            /// Mobile alert
            let mobileAlert = UIAlertAction(title: "Mobile", style: .default, handler: { mobileType in
                self.typeContact = .mobile
                self.collectionView.reloadData()
            })
            
            /// Email alert
            let emailAlert = UIAlertAction(title: "Email", style: .default, handler: { mobileType in
                self.typeContact = .email
                self.collectionView.reloadData()
            })
            
            /// Cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            /// Actions
            selectionVC.addAction(emailAlert)
            selectionVC.addAction(mobileAlert)
            selectionVC.addAction(cancelAction)
            
            /// Dismiss picker
            countryInput?.dismissPicker(true)
            
            /// Present alert
            presentVC(selectionVC)
        }
    }
}

// MARK: - CollectionView Datasource
extension StudentContactViewController: UICollectionViewDataSource {
    
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
        case .type:
            
            let typeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleTextCell.self)", for: indexPath) as! TitleTextCell
            
            typeCell.text = typeContact == .mobile ? "Mobile" : "Email"
            typeCell.titleText = "Contact preference"
            
            return typeCell
            
        case .entry:
            
            if typeContact == .mobile {
                
                let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PhoneInputCell.self)", for: indexPath) as! PhoneInputCell
                
                /// Keyboard setup
                phoneInputCell = inputCell
                inputCell.dividerView.isHidden = true
                
                inputCell.delegate = self
                inputCell.textField.returnKeyType = .next
                countryInput = inputCell.countryInput
                inputCell.titleText = "Mobile number"
                inputCell.countryInput.viewForPicker = view
                inputCell.placeholder = "e.g. (555) 867-5309"
                
                return inputCell
            }
            
            let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FormInputCell.self)", for: indexPath) as! FormInputCell
            
            inputCell.indexPath = indexPath
            
            inputCell.delegate = self
            inputCell.titleText = "Email"
            inputCell.placeholder = "email@hiclark.com"
            
            inputCell.dividerView.isHidden = true
            inputCell.formInput.autocapitalizationType = .none
            
            return inputCell
        }
    }
}

// MARK: - Phone input delegate
extension StudentContactViewController: PhoneInputCellDelegate {
    /// Country selection pressed
    func phoneInputCell(_ cell: PhoneInputCell, tapped countryPicker: CountryInput) {
        view.endEditing(true)
        
        if countryPicker.selectedCountryCode != countryCode {
            phoneInputCell?.textField.text = ""
        }
        
        countryCode = countryPicker.selectedCountryCode
    }
    
    /// Phone entered
    func phoneInputCell(_ cell: PhoneInputCell, phoneNumber: String?) {
        cell.countryInput.dismissPicker(true)
        
        /// Update params
        phone = phoneNumber
    }
}

extension StudentContactViewController: FormInputCellDelegate {
    func textFieldDidChange(_ textView: UITextView, indexPath: IndexPath) {
        email = textView.text
    }
}
