//
//  SynchronizerHandler.swift
//  consumer
//
//  Created by Vladislav Zagorodnyuk on 2/18/16.
//  Copyright © 2016 Human Ventures Co. All rights reserved.
//

import Foundation

let SynchronizerHandlerSynchronizedNotificationKey = "SynchronizerHandlerSynchronizedNotificationKey"

class SynchronizerHandler: SynchronizerAdapterDelegate {

    // MARK: - Properties
    
    var showProgress = false
    
    var dataAdaptersArray: [SynchronizerAdapter] = []
    
    static let sharedSynchronizer = SynchronizerHandler()
    
    var synchronized: Bool = false
    
    // MARK: - Synchronization logic
    // synchronizing all adapters
    func resynchronize() {
        
        self.synchronized = false
        
        for adapter in dataAdaptersArray {
            
            adapter.synchronizeData()
        }
    }
    
    func addAdapter(_ adapter: SynchronizerAdapter) {
        
        adapter.delegate = self
        self.dataAdaptersArray.append(adapter)
    }
    
    func adapterDidSynchronized(_ adapter: SynchronizerAdapter) {
        
        var synchronized = true
        
        for adapter in dataAdaptersArray {
            if !adapter.synchronized {
                synchronized = false
            }
            
            print("--------------------")
            print(adapter, adapter.synchronized)
        }
        
        self.synchronized = synchronized
        
        if self.synchronized {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: SynchronizerHandlerSynchronizedNotificationKey), object: nil)
        }
    }
}
