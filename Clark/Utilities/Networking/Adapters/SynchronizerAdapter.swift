//
//  SynchronizerAdapter.swift
//  consumer
//
//  Created by Vladislav Zagorodnyuk on 2/19/16.
//  Copyright © 2016 Human Ventures Co. All rights reserved.
//

import Foundation

protocol SynchronizerAdapterDelegate {
    
    func adapterDidSynchronized(_ adapter: SynchronizerAdapter)
}

class SynchronizerAdapter {

    // MARK: - Delegates
    var delegate: SynchronizerAdapterDelegate?
    
    // MARK: - Properties
    var synchronized = false
    
    var updateNotificationKey: String?
    
    // MARK: - Initialization methods
    
    class func modelName()-> String {
        
        return ""
    }
    
    class func updatedNotificationKey()-> String {
        
        return String(format: "SynchronizerAdapterUpdateNotificationFor%@", modelName())
    }
    
    class func postUpdateNoticiation(_ objectID: String?) {
        
        guard let _objectID = objectID else {
            
            print("objectID in update call is nil")
            return
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: updatedNotificationKey()), object: nil, userInfo: ["objectID": _objectID])
    }
    
    // MARK: - Synchronization logic 
    
    func synchronizeData() {
        
        synchronized = true
        
        if delegate != nil {
            delegate?.adapterDidSynchronized(self)
        }
    }
}
