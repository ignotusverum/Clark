//
//  ClientDetailsLearningPlanViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/8/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import PromiseKit
import SVProgressHUD

/// Type of cells
enum ClientDetailsLearningPlanCells {
    
    case duration
    
    case tutor
    case student
    case dimentions
    case session
    
    case cancelation
}

class ClientDetailsLearningPlanViewController: UIViewController {
    
    /// Student
    var learningPlan: LearningPlan
    
    /// Datasource
    var datasource: [ClientDetailsLearningPlanCells] = [.duration, .student, .tutor, .dimentions, .session, .cancelation]
    
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
        collectionView.register(TitleDetailsCell.self, forCellWithReuseIdentifier: "\(TitleDetailsCell.self)")
        collectionView.register(LearningPlanDetailsDimentionCell.self, forCellWithReuseIdentifier: "\(LearningPlanDetailsDimentionCell.self)")
        collectionView.register(ExpandableTextCell.self, forCellWithReuseIdentifier: "\(ExpandableTextCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Init
    init(learningPlan: LearningPlan) {
        self.learningPlan = learningPlan
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ScheduleDetailsViewController aDecoder not implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Fetch all dimentions
        let _ = LearningPlanAdapter.fetchDimentions(learningPlan: learningPlan).then { response-> Void in
            
        }
        
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
extension ClientDetailsLearningPlanViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
    }
}

// MARK: - CollectionView Datasource
extension ClientDetailsLearningPlanViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        /// Set cell height
        var height: CGFloat = 0
        let type = datasource[indexPath.row]
        
        switch type {
        case .duration:
            
            height = learningPlan.student?.closestSession != nil ? 67 : 0
        case .cancelation:
            
            height = 67
        case .dimentions:
            
            height = LearningPlanDetailsDimentionCell.calculateHeight(learningPlan.dimensionsArray)
        case .tutor:
            
            height = ExpandableTextCell.calculatedHeight(text: learningPlan.expectationsModel.tutor)
        case .student:
            
            height = ExpandableTextCell.calculatedHeight(text: learningPlan.expectationsModel.student)
        case .session:
            
            height = ExpandableTextCell.calculatedHeight(text: learningPlan.expectationsModel.session)
        default:
            
            height = 0
        }
        
        return CGSize(width: collectionView.frame.width, height: height)
    }
}

// MARK: - CollectionView Datasource
extension ClientDetailsLearningPlanViewController: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        /// Cell type
        let type = datasource[indexPath.row]
        
        switch type {
        case .duration:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleDetailsCell.self)", for: indexPath) as! TitleDetailsCell
            
            cell.text = "Session duration"
            cell.descriptionText = learningPlan.student?.closestSession?.durationCopy
            
            cell.clipsToBounds = true
            
            return cell
        case .cancelation:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TitleDetailsCell.self)", for: indexPath) as! TitleDetailsCell
            
            cell.text = "Cancellation policy"
            cell.descriptionText = learningPlan.student?.cancelationType.rawValue.uppercasedPrefix(1)
            
            cell.clipsToBounds = true
            
            return cell
        case .dimentions:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(LearningPlanDetailsDimentionCell.self)", for: indexPath) as! LearningPlanDetailsDimentionCell
            
            cell.text = "Dimensions we’ll measure"
            cell.dimentions = learningPlan.dimensionsArray
            
            cell.clipsToBounds = true
            
            return cell
            
        case .tutor, .student, .session:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ExpandableTextCell.self)", for: indexPath) as! ExpandableTextCell
            
            var title = ""
            var body: String?
            
            switch type {
            case .tutor:
                title = "What you'll expect"
                body = learningPlan.expectationsModel.tutor
            case .student:
                title = "What i'll expect"
                body = learningPlan.expectationsModel.student
            case .session:
                title = "Our objectives and goals"
                body = learningPlan.expectationsModel.session
            default: break
            }
            
            cell.body = body
            cell.titleText = title
            cell.indexPath = indexPath
            
            cell.delegate = self
            
            cell.clipsToBounds = true
            
            return cell
        }
    }
}

extension ClientDetailsLearningPlanViewController: ExpandableTextCellDelegate{

    /// Did expand label
    func didExpand(indexPath: IndexPath) {
        
    }
    
    /// Did collapse label
    func didCollapse(indexPath: IndexPath) {
        
    }
}
