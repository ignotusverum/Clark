//
//  SessionDetailsProgressCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/7/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class SessionDetailsProgressCell: UICollectionViewCell, DividerCellProtocol, TitleCellProtocol, SessionDetailsCellProtocol {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Title
            titleText = "How was the session"
            
            /// Update label text
            detailsLabel.text = session.sessionReport?.rating
            
            /// Update layout
            layoutSubviews()
        }
    }
    
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
        
        let titleHeight: CGFloat = 18 + 30 + 12
        let textHeight: CGFloat = (session.sessionReport?.rating ?? "").heightWithConstrainedWidth(screenWidth, font: UIFont.defaultFont(size: 18))
        
        return (session.sessionReport?.rating ?? "").length > 0 ? titleHeight + textHeight + 24 : 0
    }
}
