//
//  CalendarViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/1/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import FSCalendar

protocol CalendarViewControllerProtocol {
    
    /// Called when date is selected
    func calendar(calendar: FSCalendar, dateSelected: Date)
}

class CalendarViewController: UIViewController {
    
    /// Delegate
    var delegate: CalendarViewControllerProtocol?
    
    /// Date
    var date: Date = Date() {
        didSet {
            
            /// Update selected date
            calendar.select(date)
        }
    }
    
    /// Calendar view
    lazy var calendar: FSCalendar = {
       
        let view = FSCalendar(frame: .zero)
        
        view.appearance.headerTitleColor = UIColor.black
        view.appearance.weekdayTextColor = UIColor.black
        
        view.appearance.todayColor = UIColor.dodgerBlue
        view.appearance.selectionColor = UIColor.trinidad
        
        view.appearance.titleFont = UIFont.defaultFont()
        view.appearance.weekdayFont = UIFont.defaultFont(size: 15)
        view.appearance.headerTitleFont = UIFont.defaultFont(style: .medium, size: 15)
        
        view.register(FSCalendarCell.self, forCellReuseIdentifier: "\(FSCalendarCell.self)")
        
        return view
    }()
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// UI Setup
        customInit()
    }
    
    /// Layout setup
    func customInit() {
        
        /// Background
        view.backgroundColor = UIColor.white
        
        /// Calendar
        view.addSubview(calendar)
        calendar.delegate = self
        calendar.dataSource = self
        
        /// Calendar layout
        calendar.snp.updateConstraints { maker in
            maker.top.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
    }
}

// MARK: - Calendar delegate
extension CalendarViewController: FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        delegate?.calendar(calendar: calendar, dateSelected: date)
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true///date > Date().addingTimeInterval(-60 * 60 * 24)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

// MARK: - Calendar datasource
extension CalendarViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        
        let cell = calendar.dequeueReusableCell(withIdentifier: "\(FSCalendarCell.self)", for: date, at: position)
        
        cell.titleLabel.alpha = date > Date().addingTimeInterval(-60 * 60 * 24) ? 1 : 0.2
        
        return cell
    }
}
