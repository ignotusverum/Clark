//
//  ClientsInfoViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

class ClientsInfoViewController: UIViewController {
    
    /// Student
    var student: Student
    
    /// Transition setup
    var isModal = false
    
    /// Navigation view
    lazy var navigationView: ExtendedStudentDetailsNavigationBar = {
       
        let navigationView = ExtendedStudentDetailsNavigationBar(style: .orange, presentation: .push, type: .studentDetails, student: self.student)
        
        return navigationView
    }()
    
    /// Page view controller
    lazy var pageVC: UIPageViewController = {
        
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.view.backgroundColor = UIColor.white
        
        return pageVC
    }()
    
    /// Datasource
    var controllers: [UIViewController] = []
    var datasource: [TopNavigationDatasourceType] = []
    
    /// Sessions VC
    lazy var sessionsVC: ClientDetailsSessionsViewController = {
        
        let vc = ClientDetailsSessionsViewController(student: self.student)

        vc.delegate = self
        return vc
    }()
    
    /// Details VC
    lazy var detailsVC: ClientDetailsViewController = {
       
        let vc = ClientDetailsViewController(student: self.student)
        vc.delegate = self
        return vc
    }()
    
    /// Learning plan VC
    lazy var learningPlanVC: ClientDetailsLearningPlanViewController? = {
        guard let learningPlan = self.student.learningPlanArray.first else {
            return nil
        }
        
        let vc = ClientDetailsLearningPlanViewController(learningPlan: learningPlan)
        return vc
    }()
    
    /// Selected tab
    var selectedType: TopNavigationDatasourceType = .details
    
    var currentIndex: Int = 0
    
    /// Status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Initialization
    init(student: Student, currentIndex: Int = 0) {
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("ClientsDetailsViewController aDecoder not implemented")
    }
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Background setup
        view.backgroundColor = UIColor.white
        
        /// Custom init
        customInit()
    }
    
    // MARK: - Custom init
    fileprivate func customInit() {
        
        /// Modal setup
        if isModal {
            navigationView.presentation = .modal
        }
        
        /// Navigation bar
        view.addSubview(navigationView)
        navigationView.onBack {
            if !self.isModal {
                
                self.navigationController?.heroModalAnimationType = .slide(direction: .right)
                self.navigationController?.hero_dismissViewController()
                return
            }
            
            self.navigationController?.heroModalAnimationType = .slide(direction: .down)
            self.navigationController?.hero_dismissViewController()
        }
        
        /// Called when tab selected
        navigationView.onTab { [weak self] tab in
            
            /// Sliding index
            let slidingIndex = self?.datasource.index(of: tab) ?? 0
            
            /// Switch page VC
            self?.slideToPage(index: slidingIndex, completion: nil)
            
            /// Update type
            self?.selectedType = tab
        }
        
        /// Layout - navigation extension view
        navigationView.snp.updateConstraints { maker-> Void in
            maker.height.equalTo(167)
            maker.left.equalTo(view)
            maker.right.equalTo(view)
            maker.top.equalTo(view)
        }
        
        /// Set page controller
        addChildViewController(pageVC)
        view.addSubview(pageVC.view)
        pageVC.dataSource = self
        pageVC.delegate = self

        /// Page controller layout
        pageVC.view.snp.updateConstraints { maker in
            maker.top.equalTo(167)
            maker.bottom.equalTo(self.view)
            maker.width.equalTo(self.view)
            maker.left.equalTo(self.view)
        }
        pageVC.didMove(toParentViewController: self)
        
        /// Setup datasource
        datasourceSetup()
    }
    
    // MARK: - Utilities
    fileprivate func datasourceSetup() {
        
        /// Change selected type
        selectedType = .sessions
        
        /// Permissions check
        let config = Config.shared
        if let sessionsPermissions = config.permissions?.sessionAdd, sessionsPermissions.isEnabled == true  {
            
            /// Always show sessions is enabled
            datasource.append(.sessions)
            controllers.append(sessionsVC)
        }
        else if student.sessionsArray.count > 0 {
            
            /// Always show sessions is enabled
            datasource.append(.sessions)
            controllers.append(sessionsVC)
        }
        
        /// Always show details
        datasource.append(.details)
        controllers.append(detailsVC)
        
        if student.learningPlanArray.count > 0, let learningPlanVC = learningPlanVC {
            /// Always show leaning plans
            datasource.append(.leaningPlan)
            controllers.append(learningPlanVC)
        }
        
        /// Setup controller
        pageVC.setViewControllers([controllers.first!], direction: .forward, animated: true, completion: nil)
    }
    
    func slideToPage(index: Int, completion: (() -> Void)?) {
        
        if currentIndex < index {
            
            pageVC.setViewControllers([controllers[index]], direction: .forward, animated: true, completion: {[weak self] (complete: Bool) -> Void in
                
                self?.currentIndex = index
                completion?()
            })
        }
        else if currentIndex > index {
            pageVC.setViewControllers([controllers[index]], direction: .reverse, animated: true, completion: {[weak self] (complete: Bool) -> Void in
                
                self?.currentIndex = index
                completion?()
            })
        }
    }
    
    // MARK: - Unwind to chat
    func unwindToChat() {
        /// Unwind
        hero_dismissViewController()
        
        /// Switch to home
        let window = AppDelegate.shared.window
        if let mainVC = window?.rootViewController as? MainViewController {
            
            mainVC.switchTo(.home)
        }
    }
}

extension ClientsInfoViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard var index = controllers.index(of: viewController) else {
            return nil
        }
        
        index -= 1
        
        if index < 0 {
            return nil
        }
        
        return controllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard var index = controllers.index(of: viewController) else {
            return nil
        }
        
        index += 1
        
        if index == controllers.count {
            return nil
        }
        
        return controllers[index]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension ClientsInfoViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            
            /// Safety check
            guard let viewController = pageViewController.viewControllers?[0], let index = controllers.index(of: viewController) else {
                return
            }
         
            /// Tab type
            let tab = datasource[index]
            navigationView.switchToTab(tab)
        }
    }
}

extension ClientsInfoViewController: ClientDetailsSessionsViewControllerProtocol {
    func addSessionPressed() {
        unwindToChat()
    }
}

extension ClientsInfoViewController: ClientDetailsViewControllerDelegate {
    func onCreateLearningPlan(student: Student?) {
        
        guard let student = student else {
            return
        }
        
        self.student = student
        
        /// Always show leaning plans
        datasource.append(.leaningPlan)
        controllers.append(learningPlanVC!)
        
        navigationView.student = student
        navigationView.tabSwitcherView.student = student
        navigationView.tabSwitcherView.datasourceSetup()
        navigationView.tabSwitcherView.collectionView.reloadData()
        navigationView.tabSwitcherView.selectedType = .leaningPlan
        navigationView.tabSwitcherView.updateSelection()
        
        /// Setup controller
        pageVC.setViewControllers([controllers.last!], direction: .forward, animated: true, completion: nil)
    }
}
