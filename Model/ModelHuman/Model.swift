//
//  Model.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

/// Struct that represent model JSON keys
public struct ModelJSON {
    static let id = "id"
    static let data = "data"
    static let attributes = "attributes"
    static let relationShips = "relationships"
}

@objc(Model)
open class Model: _Model, ImportableUniqueObject {
    
    // MARK: - Importable Source Protocol
    public typealias ImportSource = JSON
    
    // Unique ID key
    public static var uniqueIDKeyPath: String {
        return "id"
    }
    
    // Unique ID Type
    public typealias UniqueIDType = String
    
    public var uniqueIDValue: String {
        get { return id! }
        set { id = newValue }
    }
    
    // Update object with importable source
    public static func shouldUpdate(from source: JSON, in transaction: BaseDataTransaction) -> Bool {
        return true
    }
    
    public static func uniqueID(from source: JSON, in transaction: BaseDataTransaction) throws -> String? {
        return source["id"].string
    }
    
    // Unique ID value
    public static func shouldInsert(from source: JSON, in transaction: BaseDataTransaction) -> Bool {
        
        guard let id = source["id"].string else {
            return false
        }
        
        let object = transaction.fetchOne(From<Model>(),
                                          Where("\(ModelJSON.id) == %@", id))
        
        return object == nil
    }
    
    public func update(from source: JSON, in transaction: BaseDataTransaction) throws {
        
        try self.updateModel(with: source, transaction: transaction)
    }
    
    // New object created
    public func didInsert(from source: JSON, in transaction: BaseDataTransaction) throws {
        
        try self.updateModel(with: source, transaction: transaction)
    }
    
    public func updateFromImportSource(_ source: JSON, inTransaction transaction: BaseDataTransaction) throws {
        
        try self.updateModel(with: source, transaction: transaction)
    }
    
    func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {
        
        // ID
        id = source[ModelJSON.id].string
    }
}

