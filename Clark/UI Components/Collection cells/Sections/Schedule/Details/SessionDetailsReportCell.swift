//
//  SessionDetailsReportCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/4/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

protocol SessionDetailsReportCellDelegate {
    
    /// Did expand label
    func didExpand(session: Session)
    
    /// Did collapse label
    func didCollapse(session: Session)
}

class SessionDetailsReportCell: UICollectionViewCell, DividerCellProtocol, TitleCellProtocol, SessionDetailsCellProtocol {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Title
            titleText = "What we did"
            
            /// Update label text
            detailsLabel.text = session.sessionReport?.body
            
            /// Update layout
            layoutSubviews()
        }
    }
    
    /// Delegate
    var delegate: SessionDetailsReportCellDelegate?
    
    /// Expandable Label
    lazy var detailsLabel: UILabel = {
        
        let label = UILabel()
        
        return label
    }()
    
    /// Divider view
    lazy var dividerView: UIView = self.generateDividerView()
    
    /// Title text
    var titleText: String! {
        didSet {
            
            /// Title setup
            titleLabel.text = titleText
        }
    }
    
    /// Title label
    lazy var titleLabel: UILabel = self.generateTitleLabel()
    
    /// Layout setup
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Divider setup
        dividerLayout()
        
        /// Title setup
        titleLabelLayout()
        
        /// Details label
        addSubview(detailsLabel)
        
        /// Details layout
        detailsLabel.snp.updateConstraints { maker in
            maker.top.equalTo(self).offset(titleLabel.bottom + 12)
            maker.left.equalTo(self).offset(24)
            maker.right.equalTo(self).offset(-24)
            maker.bottom.equalTo(self).offset(-24)
        }
    }
    
    /// Calculated height
    class func calculatedHeight(session: Session)-> CGFloat{
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        
        let titleHeight: CGFloat = 18 + 24 + 12
        let textHeight: CGFloat = (session.sessionReport?.body ?? "").heightWithConstrainedWidth(screenWidth, font: UIFont.defaultFont(size: 18))
        
        return (session.sessionReport?.body ?? "").length > 0 ? titleHeight + textHeight + 24 : 0
    }
}

/// Expanding label delegate
extension SessionDetailsReportCell: ExpandableLabelDelegate {
    
    func didExpandLabel(_ label: ExpandableLabel) {
        delegate?.didExpand(session: session)
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        delegate?.didCollapse(session: session)
    }
    
    func willExpandLabel(_ label: ExpandableLabel) {}
    func willCollapseLabel(_ label: ExpandableLabel) {}
}
