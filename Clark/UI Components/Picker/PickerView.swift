//
//  PickerView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 8/29/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit

protocol PickerViewDelegate {
    func picker(selectIndex: Int)
}

class PickerView: UIView {
    
    var delegate: PickerViewDelegate?
    
    /// Container
    lazy var pickerContainer: UIView = {
       
        let view = UIView()
        
        return view
    }()
    
    /// View for picker
    var viewForPicker: UIView
    
    /// Done button
    lazy var doneButton: UIButton = {
       
        let button = UIButton()
        
        button.setTitle("DONE", for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.titleLabel?.font = UIFont.defaultFont()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setBackgroundColor(UIColor.white, forState: .normal)
        
        button.addTarget(self, action: #selector(onDone), for: .touchUpInside)
        
        return button
    }()
    
    /// Picker view
    lazy var pickerView: UIPickerView = {
       
        let view = UIPickerView()
        return view
    }()
    
    /// Picker datasorce
    var datasource: [String]
    
    // MARK: - Custom init
    init(datasource: [String], viewForPicker: UIView) {
        
        self.datasource = datasource
        self.viewForPicker = viewForPicker
        
        super.init(frame: CGRect(x: 0, y: 0, w: viewForPicker.bounds.width, h: 224))
        
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func customInit() {
        
        /// Picker setup
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white
        pickerView.backgroundColor = UIColor.white
        pickerContainer.backgroundColor = UIColor.white
        
        /// Add picker view
        pickerContainer.addSubview(pickerView)
        pickerView.snp.updateConstraints { maker in
            maker.top.equalTo(pickerContainer).offset(40)
            maker.left.equalTo(pickerContainer)
            maker.right.equalTo(pickerContainer)
            maker.bottom.equalTo(pickerContainer).offset(-40)
        }
        
        /// Add done button
        pickerContainer.addSubview(doneButton)
        doneButton.snp.updateConstraints { maker in
            maker.top.equalTo(pickerContainer)
            maker.right.equalTo(pickerContainer).offset(-20)
            maker.height.equalTo(40)
            maker.width.equalTo(80)
        }
    }
    
    func present() {
        
        UIView.animate(withDuration: 0.1) {
        
            if !self.viewForPicker.subviews.contains(self.pickerContainer) {
                self.viewForPicker.addSubview(self.pickerContainer)
            }
            
            self.pickerContainer.snp.updateConstraints { maker in
                maker.bottom.equalTo(0)
                maker.left.equalTo(self.viewForPicker)
                maker.right.equalTo(self.viewForPicker)
                maker.height.equalTo(224)
            }
            
            self.layoutSubviews()
        }
    }
    
    func hide() {
        
        if viewForPicker.subviews.contains(pickerContainer) {

            UIView.animate(withDuration: 0.1) {
             
                self.pickerContainer.snp.updateConstraints { maker in
                    maker.bottom.equalTo(0).offset(-224)
                    maker.left.equalTo(self.viewForPicker)
                    maker.right.equalTo(self.viewForPicker)
                    maker.height.equalTo(224)
                }
                
                self.layoutSubviews()
                self.pickerContainer.removeFromSuperview()
            }
        }
    }
    
    // MARK: - ACtion
    func onDone() {
        
        hide()
    }
}

extension PickerView: UIPickerViewDelegate {
 
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.picker(selectIndex: row)
    }
}

extension PickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let newView = UIView(x: 0, y: 0, w: viewForPicker.bounds.width, h: 70)
        
        let label = UILabel(x: 0, y: 0, w: viewForPicker.bounds.width, h: 70)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.defaultFont()
        
        label.text = datasource[row]
        
        newView.addSubview(label)
        
        return newView
    }
}
