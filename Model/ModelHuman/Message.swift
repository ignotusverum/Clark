//
//  Message.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit
import TwilioChatClient

public enum ShowTypingType: String {
    case afterUserInput = "after_user_input"
    case immediately = "immediately"
}

public enum InputDecoration: String {
    case secureLock = "secure_lock"
}

public enum QuickReplyLayout:String {
    case stacked = "stacked_list"
    case horizontal = "horizontal_list"
}

/// Struct that represent Message JSON keys
public struct MessageJSON {

	static let attributes = "attributes"
    
    static let formID = "formId"
    
    static let body = "body"
	static let author = "author"
    static let channel = "channel"
    static let imageURL = "imageURL"
    
    static let blocking = "blocking"
	static let clientInputPlaceholderBody = "clientInputPlaceholderBody"
    static let clientInputDecorationString = "clientInputDecorationString"
    
    static let sent = "sent"
    
    static let typeString = "typeString"
    
    static let twilioMessageIndex = "twilioMessageIndex"
    
	static let lastSizeString = "lastSizeString"
	static let showTypingString = "showTypingString"
}

/// Message type
enum AttributeType: String {
    case text = "text"
    case html = "html"
    case image = "image"
    case timer = "timer"
    case emoji = "emoji"
    case carousel = "carousel"
    case errorText = "text_error"
    case formInput = "form_input"
    
    case undefined
}

@objc(Message)
open class Message: _Message {

    /// Message type
    var type: AttributeType {
        /// Returns undefined if new type
        return AttributeType(rawValue: typeString ?? "") ?? .undefined
    }
    
    /// Attributes
    var attributes: [String: Any] {
        return attributes_ as? [String: Any] ?? [:]
    }
    
    // MARK: - Importable Source Protocol
    public typealias ImportSource = TCHMessage
    
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
    public static func shouldUpdate(from source: TCHMessage, in transaction: BaseDataTransaction) -> Bool {
        return true
    }
    
    public static func uniqueID(from source: TCHMessage, in transaction: BaseDataTransaction) throws -> String? {
        return source.sid
    }
    
    // Unique ID value
    public static func shouldInsert(from source: TCHMessage, in transaction: BaseDataTransaction) -> Bool {
        
        guard let id = source.sid else {
            return false
        }
        
        let object = transaction.fetchOne(From<Message>(),
                                          Where("\(ModelJSON.id) == %@", id))
        
        return object == nil
    }
    
    public func update(from source: TCHMessage, channelID: String, in transaction: BaseDataTransaction) throws {
        
        try updateModel(with: source, channelID: channelID, transaction: transaction)
    }
    
    // New object created
    public func didInsert(from source: TCHMessage, channelID: String, in transaction: BaseDataTransaction) throws {
        
        try updateModel(with: source, channelID: channelID, transaction: transaction)
    }
    
    public func updateFromImportSource(_ source: TCHMessage, channelID: String, inTransaction transaction: BaseDataTransaction) throws {
        
        try updateModel(with: source, channelID: channelID, transaction: transaction)
    }
    
    func updateModel(with source: TCHMessage, channelID: String, transaction: BaseDataTransaction) throws {
        
        // ID
        id = source.sid

        /// Channel
        channel = channelID
        
        /// Attribtes
        attributes_ = source.attributes()
        
        /// Author
        author = source.author
        
        /// Body
        body = source.body
        
        /// Sent Date
        sent = source.timestampAsDate
        
        /// Twillio index
        twilioMessageIndex = source.index
        
        /// Attributes parsing
        let attributesJSON = JSON(attributes)
         
        /// Blocking
        blocking = attributesJSON[MessageJSON.blocking].number ?? NSNumber(value: false)
        
        /// Client decorations
        clientInputPlaceholderBody = attributesJSON[MessageJSON.clientInputPlaceholderBody].string
        clientInputDecorationString = attributesJSON[MessageJSON.clientInputDecorationString].string
        
        /// Form Id
        formID = attributesJSON[MessageJSON.formID].string
        
        /// Image URL
        imageURL = attributesJSON[MessageJSON.imageURL].string
        
        /// Last size
        lastSizeString = attributesJSON[MessageJSON.lastSizeString].string
        
        /// Show Typing
        showTypingString = attributesJSON[MessageJSON.showTypingString].string
        
        /// Type
        typeString = attributesJSON[MessageJSON.typeString].string
    }
}
