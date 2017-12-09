//
//  AlrertHelper.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 7/6/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Alert helper
class AlertHelper{
    // Show native ios alert
    class func showAlert(title: String, msg: String? = nil, controller: UIViewController) {
        DispatchQueue.main.async(execute: {
            let alertController = UIAlertController(title: title, message:
                msg, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            controller.present(alertController, animated: true, completion: nil)
        })
    }
    
    // Format error msgs
    class func formatErrorMsg(_ error: String) -> String{
        return error.capitalized + "."
    }
    
    // alert with handler
    class func showAlertWithHandler(title: String, msg: String? = nil, controller: UIViewController, handler: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: handler))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    // alert with custom handler
    class func showAlertWithCustomButtonHandler(title: String, msg: String? = nil, buttonTitle : String, controller: UIViewController, handler: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: handler))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    // alert with text input
    class func showAlertWithTextInput(title: String, msg: String? = nil, placeholder:String? = nil, controller: UIViewController, handler: @escaping (UIAlertController) -> Void) {
        let alertController = UIAlertController(title: title, message:
            msg, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (field:UITextField) in
            field.placeholder = placeholder
        }
        let okAction = UIAlertAction(title: "Submit", style: .default) { (action:UIAlertAction) in
            handler(alertController)
        }
        alertController.addAction(okAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
}
