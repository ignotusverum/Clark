//
//  TimePickerViewController.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/1/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

protocol TimePickerViewControllerDelegate {
    
    /// Cancel pressed
    func timePickerOnCancel(_ picker: TimePickerViewController)
    
    /// Done pressed
    func timePickerOnDone(_ picker: TimePickerViewController, date: Date)
}

class TimePickerViewController: UIViewController {
    
    /// Delegate
    var delegate: TimePickerViewControllerDelegate?
    
    /// Done button
    lazy var doneButton: UIButton = {
       
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(UIColor.trinidad, for: .normal)
        
        return button
    }()
    
    /// Cancel button
    lazy var cancelButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor.trinidad, for: .normal)
        
        return button
    }()
    
    /// Time picker
    lazy var timePicker: UIDatePicker = {
       
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        
        return picker
    }()
    
    // MARK: - Controller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Custom init
        customInit()
    }
    
    /// Custom init
    func customInit() {
        
        /// Background view
        view.backgroundColor = UIColor.white
        
        /// Button targets
        doneButton.addTarget(self, action: #selector(onDone(_:)), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(onCancel(_:)), for: .touchUpInside)
        
        /// Done button
        view.addSubview(cancelButton)
        cancelButton.snp.updateConstraints { maker in
            maker.left.equalTo(self.view).offset(10)
            maker.top.equalTo(self.view).offset(10)
            maker.width.equalTo(80)
            maker.height.equalTo(40)
        }
        
        /// Cancel button
        view.addSubview(doneButton)
        doneButton.snp.updateConstraints { maker in
            maker.right.equalTo(self.view).offset(-10)
            maker.top.equalTo(self.view).offset(10)
            maker.width.equalTo(80)
            maker.height.equalTo(40)
        }
        
        /// Time picker
        view.addSubview(timePicker)
        
        /// Time picker layout
        timePicker.snp.updateConstraints { maker in
            maker.height.equalTo(self.view).offset(-50)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.bottom.equalTo(self.view)
        }
    }
    
    // MARK: - Actions
    func onCancel(_ sender: UIButton) {
        delegate?.timePickerOnCancel(self)
    }
    
    func onDone(_ sender: UIButton) {
        delegate?.timePickerOnDone(self, date: timePicker.date)
    }
}
