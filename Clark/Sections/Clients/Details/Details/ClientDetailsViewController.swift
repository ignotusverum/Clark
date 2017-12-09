//
//  ClientDetailsViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PromiseKit
import SVProgressHUD

protocol ClientDetailsViewControllerDelegate {
    func onCreateLearningPlan(student: Student?)
}

/// Type of cells
enum ClientDetailsCells: String {
    
    case age
    case subject
    case rate
    case phone
    case email
    case proxy
    case learningPlan
}

class ClientDetailsViewController: UIViewController {
    
    /// Student
    var student: Student
    
    /// Datasource
    var datasource: [ClientDetailsCells] = [.age, .subject, .rate, .email, .phone, .proxy, .learningPlan]
    
    /// Delegate
    var delegate: ClientDetailsViewControllerDelegate?
    
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
        
        /// Cell registration
        collectionView.register(ClientDetailsSubjectsCell.self, forCellWithReuseIdentifier: "\(ClientDetailsSubjectsCell.self)")
        collectionView.register(ClientDetailsProxyCell.self, forCellWithReuseIdentifier: "\(ClientDetailsProxyCell.self)")
        collectionView.register(ClientDetailsAgeCell.self, forCellWithReuseIdentifier: "\(ClientDetailsAgeCell.self)")
        collectionView.register(ClientDetailsRateCell.self, forCellWithReuseIdentifier: "\(ClientDetailsRateCell.self)")
        collectionView.register(ClientDetailsEmailCell.self, forCellWithReuseIdentifier: "\(ClientDetailsEmailCell.self)")
        collectionView.register(ClientDetailsPhoneCell.self, forCellWithReuseIdentifier: "\(ClientDetailsPhoneCell.self)")
        collectionView.register(ClientDetailsAddLearningPlanCell.self, forCellWithReuseIdentifier: "\(ClientDetailsAddLearningPlanCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Init
    init(student: Student) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ScheduleDetailsViewController aDecoder not implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Analytics
        Analytics.screen(screenId: .s8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup banner code
        BannerManager.manager.viewController = self
        BannerManager.manager.errorMessageHiddenForCategory = { category in
            print(category)
        }
        
        /// Custom init
        customInit()
    }
    
    func customInit() {
        
        /// Collection view
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        /// Collection layout
        collectionView.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.bottom.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
        }
    }
}

// MARK: - CollectionView Delegate
extension ClientDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellType = datasource[indexPath.row]
        
        /// Analytics
        Analytics.trackEventWithID(.s8_0, eventParams: ["type": cellType.rawValue])
        
        if cellType == .learningPlan {
            
            /// Transition to create new learning plan
            let createLearningPlanFlow = ClientsRouteHandler.createLearningPlanTransition(student: student)
            
            /// Called when session created
            createLearningPlanFlow.1.onFlowCompleted({ learningPlan in
                let _ = SessionAdapter.fetchList().then { response-> Void in
                    let _ = StudentAdapter.fetch(studentID: self.student.id).then { response-> Void in
                        self.collectionView.reloadData()
                        self.delegate?.onCreateLearningPlan(student: response)
                    }
                }
            })
            
            presentVC(createLearningPlanFlow.0)
            
            /// Analytics
            Analytics.trackEventWithID(.s8_2, eventParams: ["id": student.id])
        }
    }
}

// MARK: - CollectionView Datasource
extension ClientDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        var cellHeight: CGFloat = 0
        
        let cellType = datasource[indexPath.row]
        switch cellType {
        case .proxy:
            cellHeight = ClientDetailsProxyCell.calculatedHeight(student: student)
        case .subject:
            cellHeight = ClientDetailsSubjectsCell.calculatedHeight(student: student)
        case .age:
            cellHeight = ClientDetailsAgeCell.calculatedHeight(student: student)
        case .rate:
            cellHeight = ClientDetailsRateCell.calculatedHeight(student: student)
        case .phone:
            cellHeight = ClientDetailsPhoneCell.calculatedHeight(student: student)
        case .email:
            cellHeight = ClientDetailsEmailCell.calculatedHeight(student: student)
        case .learningPlan:
            cellHeight = 0
            
            /// Permissions check
            let config = Config.shared
            if let learningPlansPermissions = config.permissions?.learningPlans, learningPlansPermissions.isEnabled == true {
                cellHeight = ClientDetailsAddLearningPlanCell.calculatedHeight(student: student)
            }
        }
        
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
}

// MARK: - CollectionView Datasource
extension ClientDetailsViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cellType = datasource[indexPath.row]
        
        /// Switch cell types
        switch cellType {
        case .age:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ClientDetailsAgeCell.self)", for: indexPath) as! ClientDetailsAgeCell
            
            cell.student = student
            cell.clipsToBounds = true
            
            return cell
        case .subject:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ClientDetailsSubjectsCell.self)", for: indexPath) as! ClientDetailsSubjectsCell
            
            cell.student = student
            cell.clipsToBounds = true
            
            return cell
        case .proxy:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ClientDetailsProxyCell.self)", for: indexPath) as! ClientDetailsProxyCell
            
            cell.student = student
            cell.clipsToBounds = true
            
            return cell
        case .rate:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ClientDetailsRateCell.self)", for: indexPath) as! ClientDetailsRateCell
            
            cell.student = student
            cell.clipsToBounds = true
            
            return cell
        case .phone:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ClientDetailsPhoneCell.self)", for: indexPath) as! ClientDetailsPhoneCell
            
            cell.student = student
            cell.clipsToBounds = true
            
            return cell
            
        case .email:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ClientDetailsEmailCell.self)", for: indexPath) as! ClientDetailsEmailCell
            
            cell.student = student
            cell.clipsToBounds = true
            
            return cell
        case .learningPlan:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ClientDetailsAddLearningPlanCell.self)", for: indexPath) as! ClientDetailsAddLearningPlanCell
            
            cell.student = student
            cell.clipsToBounds = true
            
            return cell
        }
    }
}
