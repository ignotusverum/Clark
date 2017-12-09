//
//  ActionSheetView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import EZSwiftExtensions

protocol ActionSheetViewDelegate {
    func onAction(_ action: ActionSheetModel)

}

class ActionSheetView: UIView {

    var delegate: ActionSheetViewDelegate?
    
    /// Datasource
    let actionModels: [ActionSheetModel] = [ActionSheetModel(type: .student), ActionSheetModel(type: .session), ActionSheetModel(type: .feedback), ActionSheetModel(type: .profile), ActionSheetModel(type: .cancel), ActionSheetModel(type: .reschedule)]
    
    /// Closure for detecting view tapped
    private var viewTapped: (()->())?
    
    /// Status
    var isOpen: Bool = false {
        didSet {
            
            if isOpen {
                
                UIView.animate(withDuration: 0.2, delay: 0.1, animations: {
                    
                    self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                }, completion: nil)
            }
            else {
                
                backgroundColor = UIColor.clear
            }
        }
    }
    
    lazy var backgroundView: UIVisualEffectView = {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = UIColor.white
        
        blurEffectView.alpha = 0.8
        
        return blurEffectView
    }()
    
    /// Collection view
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 0)
        
        collectionView.backgroundColor = UIColor.clear
        
        /// Disable scrolling indicataor
        collectionView.showsHorizontalScrollIndicator = false
        
        /// Register cells
        collectionView.register(ActionSheetCollectionViewCell.self, forCellWithReuseIdentifier: "\(ActionSheetCollectionViewCell.self)")
        
        return collectionView
    }()
    
    // MARK: - Initialiation
    init() {
        super.init(frame: .zero)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom initialization
    private func customInit() {
        
        /// Reload data
        collectionView.reloadData()
        
        /// Blur view
        addSubview(backgroundView)
        
        /// Collection vie
        addSubview(collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        
        /// Collection view layout
        let yPosition = isOpen ? 0 : 170
        collectionView.snp.updateConstraints { make in
            make.bottom.equalTo(yPosition)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(130)
        }
        
        /// Blur view
        backgroundView.snp.updateConstraints { make in
            make.bottom.equalTo(yPosition)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(130)
        }
        
        collectionView.reloadData()
        
        if collectionView.bounds.height > 0 {
            let maskPAth1 = UIBezierPath(roundedRect: backgroundView.bounds,
                                         byRoundingCorners: [.topLeft , .topRight],
                                         cornerRadii:CGSize(width: 8, height: 8))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame = self.bounds
            maskLayer1.path = maskPAth1.cgPath
            backgroundView.layer.mask = maskLayer1
        }
        
        if isOpen {
            
            UIView.animate(withDuration: 0.2, delay: 0.1, animations: {

                self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            }, completion: nil)
        }
        else {
            
            backgroundColor = UIColor.clear
        }
    }
    
    // MARK: - Touch detection
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isOpen = !isOpen
        
        /// Run tap closure
        viewTapped?()
    }
    
    /// Function to handle closure in parent
    func onTap(_ completion: (()->())?) {
        
        /// Completion handler
        viewTapped = completion
    }
}

// MARK: - CollectionView Delegate
extension ActionSheetView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// Passing model to protocol
        let cell = collectionView.cellForItem(at: indexPath) as! ActionSheetCollectionViewCell
        delegate?.onAction(cell.actionModel)
        
        isOpen = !isOpen
    }
}

// MARK: - CollectionView Datasource
extension ActionSheetView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
        
        return CGSize(width: collectionView.frame.width / 3.5, height: collectionView.frame.height)
    }
}

// MARK: - CollectionView Datasource
extension ActionSheetView: UICollectionViewDataSource {
    
    /// Number of sections
    func numberOfSections(in collectionView: UICollectionView)-> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)-> Int {
        return actionModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ActionSheetCollectionViewCell.self)", for: indexPath) as! ActionSheetCollectionViewCell
        
        let action = actionModels[indexPath.row]
        cell.actionModel = action
        
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
}
