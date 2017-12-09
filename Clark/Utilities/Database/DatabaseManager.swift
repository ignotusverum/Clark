//
//  DatabaseManager.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 6/30/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import UIKit
import CoreStore
import PromiseKit

class DatabaseManager {
    
    // Default clark Stack
    static let defaultStack: DataStack = {
        
        let bundleID = Bundle.main.bundleIdentifier!
        
        let dataStack = DataStack(xcodeModelName: "Model")
        try! dataStack.addStorageAndWait(
            SQLiteStore(
                fileName: "Main.sqlite",
                localStorageOptions: .recreateStoreOnModelMismatch
        ))
        
        return dataStack
    }()
    
    class func clearDB() {
        
        let entityTypes = self.defaultStack.entityTypesByName.values
        
        _ = try? defaultStack.perform(
            synchronous: { (transaction) in
                
                entityTypes.forEach { transaction.deleteAll(From($0)) }
        })
    }
    
    // MARK: - Promises
    // MARK: - Insertion promises
    class func insertSync<T>(_ into: Into<T>, source: T.ImportSource)-> Promise<T?> where T: NSManagedObject, T: ImportableUniqueObject {
        
        return Promise { fulfill, reject in
            
            _ = try? defaultStack.perform(
                synchronous: { (transaction) in
                    
                    let importResult = try transaction.importUniqueObject(into, source: source)
                    
                    fulfill(importResult)
            })
        }
    }
    
    class func insertSync<T, S: Sequence>(_ into: Into<T>, source: S)-> Promise<[T]> where T: NSManagedObject, T: ImportableUniqueObject, S.Iterator.Element == T.ImportSource {
        
        return Promise { fulfill, reject in
            
            _ = try? defaultStack.perform(
                synchronous: { (transaction) in
                    
                    let importResult = try transaction.importUniqueObjects(into, sourceArray: source)
                    
                    fulfill(importResult)
            })
        }
    }
    
    class func insertASync<T>(_ into: Into<T>, source: T.ImportSource)-> Promise<T?> where T: NSManagedObject, T: ImportableUniqueObject {
        
        return Promise { fulfill, reject in
            
            defaultStack.perform(
                asynchronous: { transaction in
                    do {
                        
                        let importResult = try transaction.importUniqueObject(into, source: source)
                        
                        fulfill(importResult)
                    }
                    catch let error {
                        
                        reject(error)
                    }
            },
                completion: { _ in })
        }
    }
    
    class func insertASync<T, S: Sequence>(_ into: Into<T>, source: S)-> Promise<[T]> where T: NSManagedObject, T: ImportableUniqueObject, S.Iterator.Element == T.ImportSource {
        
        return Promise { fulfill, reject in
            
            defaultStack.perform(
                asynchronous: { transaction in
                    do {
                        
                        let importResult = try transaction.importUniqueObjects(into, sourceArray: source)
                        
                        fulfill(importResult)
                    }
                    catch let error {
                        
                        reject(error)
                    }
            },
                completion: { _ in })
        }
    }
    
    // MARK: - Deletion promises
    class func deleteASync<S: Sequence>(_ objects: S)-> Promise<Bool> where S.Iterator.Element: NSManagedObject {
        
        return Promise { fulfill, reject in
            
            defaultStack.perform(
                asynchronous: { transaction in
                    transaction.delete(objects)
                    
                    fulfill(true)
            },
                completion: { _ in })
        }
    }
    
    class func fetchExisting<T: NSManagedObject>(_ object: T?)-> Promise<T?> {
        return Promise { fulfill, reject in
            
            if let object = object {
                fulfill(self.defaultStack.fetchExisting(object))
            }
            
            fulfill(object)
        }
    }
    
    class func fetchExisting<T: NSManagedObject, S: Sequence>(_ objects: S)-> Promise<[T]> where S.Iterator.Element == T {
        return Promise { fulfill, reject in
            
            fulfill(self.defaultStack.fetchExisting(objects))
        }
    }
    
    class func fetchAsyncExisting<T: NSManagedObject>(_ object: T?)-> Promise<T?> {
        return Promise { fulfill, reject in
            
            if let object = object {
                
                defaultStack.perform(
                    asynchronous: { transaction in
                        fulfill(transaction.fetchExisting(object))
                },
                    completion: { _ in })
            }
            
            fulfill(object)
        }
    }
    
    class func fetchAsyncExisting<T: NSManagedObject, S: Sequence>(_ objects: S)-> Promise<[T]> where S.Iterator.Element == T {
        return Promise { fulfill, reject in
            
            defaultStack.perform(
                asynchronous: { transaction in
                    fulfill(transaction.fetchExisting(objects))
            },
                completion: { _ in })
        }
    }
}

