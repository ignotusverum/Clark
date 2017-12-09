//
//  StudentProxyViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/29/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import Popover
import EZSwiftExtensions

enum StudentProxyCells {
    
    case firstName
    case lastName
    
    case relationship
    
    case type
    case entry
}

class StudentProxyViewController: UIViewController, HelpNavigationProtocol, CreationViewControllerProtocol {
    
    /// On next
    var nextButtonSuccess: ((_ firstName: String, _ lastName: String, _ relationship: String, _ email: String, _ phone: String)->())?
    
    /// Title
    var navigationTitle: String
    
    /// Popover view
    lazy var popover: Popover? = self.generatePopover()
    
    /// Progress view
    lazy var progressView: UIView = self.generateProgressView()
    
    /// Help copy
    var helpCopy: String? {
        return "Any communication will have to go to a parent or guardian to stay compliant with COPPA"
    }
    
    /// Datasource
    var datasource: [StudentProxyCells] = [.firstName, .lastName, .relationship, .type, .entry]
    
    /// Country input
    var countryInput: CountryInput?
    
    /// Datasource
    var typeContact: StudentContactType = .mobile
    
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
        collectionView.register(PhoneInputCell.self, forCellWithReuseIdentifier: "\(PhoneInputCell.self)")
        collectionView.register(TitleTextCell.self, forCellWithReuseIdentifier: "\(TitleTextCell.self)")
        collectionView.register(TitleDescriptionHader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "\(TitleDescriptionHader.self)")
        
        return collectionView
    }()
    
    /// Validation values
    var firstName: String?
    var lastName: String?
    
    var phone: String?
    var email: String?
    var countryCode: String = "US"
    
    var relationship: String = "Parent"
    let relationships: [String] = ["Parent", "Guardian", "Caretaker", "Other"]
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("StudentContactViewController aDecoder not implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Controller setup
        controllerSetup()
        
        /// Track
        Analytics.screen(screenId: .s15)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        
        /// Next button action
        nextButton?.addTarget(self, action: #selector(onNextButton(_:)), for: .touchUpInside)
        
        /// Custom init
        customInit()
        
        /// Focusing first name
        ez.runThisAfterDelay(seconds: 1) {
            self.firstNameCell?.formInput.becomeFirstResponder()
        }
        
        collectionView.reloadData()
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
        let entry = typeContact == .mobile ? phone : email
        
        if let nameError = Validation.validateName(first: firstName, last: lastName) {
            
            /// Show error
            BannerManager.manager.showBannerForErrorText(nameError.copy(), category: .all)
            return
        }
        
        if let phoneError = Validation.validateContactType(type: typeContact, entry: entry, country: countryCode) {
         
            /// Show error
            BannerManager.manager.showBannerForErrorText(phoneError.copy(), category: .all)
            return
        }

        /// Callback
        nextButtonSuccess?(firstName!, lastName!, relationship, email ?? "", phone ?? "")
    }
    
    func onHelpButton(_ sender: UIButton) {
        showPopoveView()
    }
    
    /// On next button callback
    func onNextButtonCallback(_ completion: @escaping ((_ firstName: String, _ lastName: String, _ relationship: String, _ email: String, _ phone: String)->())) {
        nextButtonSuccess = completion
    }
    
    // MARK: - Scroll view
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - CollectionView Datasource
extension StudentProxyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 180)
    }
    
    /// Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            /// Header setup
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(TitleDescriptionHader.self)", for: indexPath) as! TitleDescriptionHader
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.lineSpacing = 10
            
            headerView.titleLabel.attributedText = NSAttributedString(string: "We need to speak with an adult…", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            let paragraph2 = NSMutableParagraphStyle()
            paragraph2.lineSpacing = 5
            headerView.descriptionLabel.attributedText = NSAttributedString(string: "e.g. for session reminders,\nreports, or payment notifications", attributes: [NSParagraphStyleAttributeName: paragraph])
            
            return headerView
            
        default:
            print("ignore")
            return UICollectionReusableView(frame: .zero)
        }
    }
}

// MARK: - CollectionView Delegate
extension StudentProxyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// Dismiss picker
        countryInput?.dismissPicker(true)
        
        /// Hide keyboard
        view.endEditing(true)
        
        let type = datasource[indexPath.row]
        if type == .type {
            
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
            selectionVC.addAction(mobileAlert)
            selectionVC.addAction(emailAlert)
            selectionVC.addAction(cancelAction)
            
            /// Present alert
            presentVC(selectionVC)
        }
        else if type == .relationship {
            
            /// Present alert selector
            let selectionVC = UIAlertController(title: "Relations", message: nil, preferredStyle: .actionSheet)
            
            selectionVC.view.tintColor = UIColor.trinidad
            
            for copy in relationships {
                let alert = UIAlertAction(title: copy, style: .default, handler: { action in
                    
                    self.relationship = copy
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
extension StudentProxyViewController: UICollectionViewDataSource {
    
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
        case .firstName, .lastName:
            
            let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FormInputCell.self)", for: indexPath) as! FormInputCell
            
            var title = ""
            switch type {
            case .firstName:
                title = "First name"
                firstNameCell = inputCell
            case .lastName:
                title = "Last name"
            default:
                print("not handled")
            }
            
            inputCell.delegate = self
            inputCell.titleText = title
            inputCell.indexPath = indexPath
            inputCell.placeholder = "e.g. Clark"
            inputCell.formInput.returnKeyType = .next
            
            return inputCell
        case .type:
            
            let typeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleTextCell.self)", for: indexPath) as! TitleTextCell
            
            typeCell.text = typeContact == .mobile ? "Mobile" : "Email"
            typeCell.titleText = "Contact preference"
            
            return typeCell
            
        case .relationship:
            
            let typeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleTextCell.self)", for: indexPath) as! TitleTextCell
            
            typeCell.text = relationship
            typeCell.titleText = "Relationship"
            
            return typeCell
            
        case .entry:
            
            if typeContact == .mobile {
                
                let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PhoneInputCell.self)", for: indexPath) as! PhoneInputCell
                
                inputCell.delegate = self
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

// MARK: - Text Input delegate
extension StudentProxyViewController: FormInputCellDelegate {
    
    /// Return button pressed
    func textFieldHitReturn(_ textVies: UITextView, indexPath: IndexPath){
        
        let type = datasource[indexPath.row]
        if type == .entry {
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
        case .entry:
            email = typeContact == .email ? textView.text : nil
        default:
            print("Yo")
        }
    }
}

// MARK: - Phone input delegate
extension StudentProxyViewController: PhoneInputCellDelegate {
    /// Country selection pressed
    func phoneInputCell(_ cell: PhoneInputCell, tapped countryPicker: CountryInput) {
        view.endEditing(true)
        countryCode = countryPicker.selectedCountryCode
    }
    
    /// Phone entered
    func phoneInputCell(_ cell: PhoneInputCell, phoneNumber: String?) {
        cell.countryInput.dismissPicker(true)
        
        /// Update params
        phone = phoneNumber
    }
}
