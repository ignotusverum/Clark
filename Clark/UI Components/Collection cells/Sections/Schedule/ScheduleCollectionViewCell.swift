//
//  ScheduleCollectionViewCell.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

class ScheduleCollectionViewCell: UICollectionViewCell {
    
    /// Session
    var session: Session! {
        didSet {
            
            /// Setup
            customInit()
        }
    }

    /// Info View
    lazy var infoView: UIView = {
       
        let view = UIView()
        return view
    }()
    
    /// Name label
    lazy var nameLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.white
        
        return label
    }()
    
    /// Time label
    lazy var timeLabel: UILabel = {
       
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.defaultFont(style: .light, size: 17)
        label.textColor = UIColor.white
        
        return label
    }()
    
    /// Day number label
    lazy var dayNumberLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.defaultFont(style: .semiBold, size: 32)
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    /// Day of week label
    lazy var dayOfWeekLabel: UILabel = {
        
        let label = UILabel()
        label.font = UIFont.defaultFont(size: 13)
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        
        /// Info view
        addSubview(infoView)
        
        /// Name label
        infoView.addSubview(nameLabel)
        
        /// Time label
        infoView.addSubview(timeLabel)
        
        /// Day of the week
        addSubview(dayOfWeekLabel)
        
        /// Day number
        addSubview(dayNumberLabel)
        
        /// Info view layout
        infoView.snp.updateConstraints { maker in
            maker.left.equalTo(100)
            maker.right.equalTo(self).offset(-16)
            maker.height.equalTo(64)
            maker.top.equalTo(16)
        }
        
        /// Name label
        nameLabel.snp.updateConstraints { maker in
            maker.left.equalTo(12)
            maker.right.equalTo(12)
            maker.top.equalTo(8)
            maker.height.equalTo(20)
        }
        
        /// Day number label
        dayNumberLabel.snp.updateConstraints { maker in
            maker.left.equalTo(14)
            maker.width.equalTo(70)
            maker.top.equalTo(infoView.top).offset(16)
        }
        
        /// Day of the week
        dayOfWeekLabel.snp.updateConstraints { maker in
            maker.width.equalTo(60)
            maker.left.equalTo(16)
            maker.top.equalTo(dayNumberLabel.top + dayNumberLabel.frame.height).offset(52)
        }
        
        /// time label
        timeLabel.snp.updateConstraints { maker in
            maker.left.equalTo(12)
            maker.right.equalTo(12)
            maker.bottom.equalTo(infoView).offset(-8)
            maker.height.equalTo(20)
        }
        
        infoView.layer.cornerRadius = 5
    }
    
    // MARK: - Custom setup
    private func customInit() {
     
        // Time
        var start = session.localStartTime(format: "h") ?? ""
        let startMinute = session.localStartTime(format: "mm") ?? ""
        var end = session.localEndTime(format: "h") ?? ""
        let endMinute = session.localEndTime(format: "mm") ?? ""
        let endAMPM = session.localEndTime(format: "a") ?? ""
        
        if startMinute != "00" {
            start += ":" + startMinute
        }
        if endMinute != "00" {
            end += ":" + endMinute
        }
        
        var timeString = start + "-" + end + " " + endAMPM
        
        // Configure for status and produce status string if applicable
        var statusString:String?
        switch session.status {
        case .paid:
            statusString = "Paid"
        
        case .pending:
            statusString = "Pending"
            
        case .paymentDeclined:
            statusString = "Payment Declined"
            
        case .rescheduled:
            statusString = "Rescheduled"
            
        case .cancelled:
            statusString = "Cancelled"
        default: break
        }
        
        if let statusString = statusString {
            timeString += " • " + statusString
        }
        
        /// Background setup
        dayNumberLabel.textColor = UIColor.pastColor
        infoView.backgroundColor = UIColor.pastColor
        dayOfWeekLabel.textColor = UIColor.pastColor
        
        let currentDate = session.localStartTime(format: "dd MMMM yyyy")
        let date = Date.localDateString(Date(), format: "dd MMMM yyyy")
        
        if session.startTime ?? Date() > Date() {
            dayNumberLabel.textColor = UIColor.black
            infoView.backgroundColor = UIColor.futureColor
        }
        else if currentDate == date {
            dayNumberLabel.textColor = UIColor.trinidad
            infoView.backgroundColor = UIColor.futureColor
            dayOfWeekLabel.textColor = UIColor.futureColor
        }
        
        nameLabel.text = session.student?.fullName ?? ""
        timeLabel.text = timeString
    }
}
