//
//  AccountDetailsViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/14/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import SVProgressHUD

enum AccountDetailsCells: String {
    
    case firstName = "First Name"
    case lastName = "Last Name"
    
    case phone = "Phone"
    
    case subjects = "Subjects"
    
    case bio = "Bio"
}

class AccountDetailsViewController: UIViewController {
    
    /// Tutor
    var tutor: Tutor
    
    /// Request dict
    var requestDict: [String: Any] = [:]
    
    /// Phone cell
    var phoneCell: PhoneInputCell?
    
    /// Country input
    var countryInput: CountryInput?
    
    var countryCode: String = "US"
    
    /// Datasource
    let datasource: [AccountDetailsCells] = [.firstName, .lastName, .phone, .subjects, .bio]
    
    /// Right button
    lazy var rightButton: UIBarButtonItem = {
       
        let button = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(onSaveButton(_:)))
        button.tintColor = UIColor.trinidad
        button.setTitleTextAttributes([NSFontAttributeName: UIFont.defaultFont(style: .medium, size: 14)], for: .normal)
        
        return button
    }()
    
    /// Collection View
    var collectionView: UICollectionView = {
        
        /// Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        /// Collection view
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        
        /// Register cells
        collectionView.register(FormInputCell.self, forCellWithReuseIdentifier: "\(FormInputCell.self)")
        collectionView.register(PhoneInputCell.self, forCellWithReuseIdentifier: "\(PhoneInputCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Init
    init(tutor: Tutor) {
        self.tutor = tutor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("AccountDetailsViewController init coder not implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Analytics
        Analytics.screen(screenId: .s9)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        /// Title
        setTitle("Edit Profile")
        
        /// Back icon
        setCustomBackButton(image: #imageLiteral(resourceName: "back_icon")) {
            self.navigationController?.heroModalAnimationType = .slide(direction: .right)
            self.navigationController?.hero_dismissViewController()
        }
        
        /// Custom setup
        customInt()
    }
    
    // MARK: - Custom init
    func customInt() {
        
        /// Collection view
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection view layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.bottom.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
        }
    }
    
    // MARK: - Actions
    func onSaveButton(_ sender: Any) {
        
        view.endEditing(true)
        countryInput?.dismissPicker(true)
        
        guard requestDict.count > 0 else {
            return
        }
        
        SVProgressHUD.show()
        
        /// Save updates
        TutorAdapter.update(requestDict).then { response-> Void in
            self.navigationController?.heroModalAnimationType = .slide(direction: .right)
            self.navigationController?.hero_dismissViewController()
            SVProgressHUD.dismiss()
            
            Analytics.trackEventWithID(.s9_1, eventParams: ["success": true])
            
            guard let response = response else {
                return
            }
            
            /// Update current tutor
            let config = Config.shared
            config.currentTutor = response
            
            }.catch { error in
                Analytics.trackEventWithID(.s9_1, eventParams: ["success": false])
                SVProgressHUD.dismiss()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// Disable dismiss for small phones
        if UIDevice.current.screenType != .iPhone5 {
            view.endEditing(true)
        }
        
        countryInput?.dismissPicker(true)
    }
}

// MARK: - CollectionView Datasource
extension AccountDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        let type = datasource[indexPath.row]
        return type == .bio ? CGSize(width: collectionView.frame.width, height: 250) : CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - CollectionView Delegate
extension AccountDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellType = datasource[indexPath.row]
        Analytics.trackEventWithID(.s9_0, eventParams: ["type": cellType.rawValue])
    }
}

// MARK: - CollectionView Datasource
extension AccountDetailsViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        /// Type
        let cellType = datasource[indexPath.row]
        
        if cellType == .phone {
            
            let inputCell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PhoneInputCell.self)", for: indexPath) as! PhoneInputCell
            
            phoneCell = inputCell
            
            inputCell.textField.text = tutor.phone
            inputCell.delegate = self
            inputCell.textField.returnKeyType = .next
            countryInput = inputCell.countryInput
            inputCell.titleText = "Mobile number"
            inputCell.countryInput.viewForPicker = view
            inputCell.placeholder = "e.g. (555) 867-5309"
            
            return inputCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(FormInputCell.self)", for: indexPath) as! FormInputCell
        cell.delegate = self
        
        /// Title
        cell.titleText = cellType.rawValue
        
        /// Placeholder
        cell.placeholder = cellType.rawValue
        
        /// Index path
        cell.indexPath = indexPath
        
        switch cellType {
        case .firstName:
            /// Form input text
            cell.formInput.text = tutor.firstName
        case .lastName:
            /// Form input text
            cell.formInput.text = tutor.lastName
        case .phone:
            /// Form input text
            print("no supported")
        case .subjects:
            /// Form input text
            cell.formInput.text = tutor.subjectsTaught
        case .bio:
            /// Form input text
            cell.formInput.text = tutor.bio
        }
        
        /// Hiding divider for last cell
        cell.dividerView.isHidden = cellType == .bio
        
        /// Number of lines
        cell.formInput.textContainer.maximumNumberOfLines = cellType == .bio ? 0 : 1
        
        return cell
    }
}

extension AccountDetailsViewController: FormInputCellDelegate {
    func textFieldDidChange(_ textView: UITextView, indexPath: IndexPath) {
        
        let type = datasource[indexPath.row]
        switch type {
        case .firstName:
            requestDict[TutorJSON.firstName] = textView.text
        case .lastName:
            requestDict[TutorJSON.lastName] = textView.text
        case .phone:
            requestDict[TutorJSON.phone] = textView.text
        case .subjects:
            requestDict[TutorJSON.subjectsTaught] = textView.text
        case .bio:
            requestDict[TutorJSON.bio] = textView.text
        }
    }
}

// MARK: - Phone input delegate
extension AccountDetailsViewController: PhoneInputCellDelegate {
    /// Country selection pressed
    func phoneInputCell(_ cell: PhoneInputCell, tapped countryPicker: CountryInput) {
        view.endEditing(true)
        
        if countryPicker.selectedCountryCode != countryCode {
            phoneCell?.textField.text = ""
        }
        
        countryCode = countryPicker.selectedCountryCode
    }
    
    /// Phone entered
    func phoneInputCell(_ cell: PhoneInputCell, phoneNumber: String?) {
        cell.countryInput.dismissPicker(true)
        
        /// Update params
        requestDict[TutorJSON.phone] = phoneNumber
    }
}
