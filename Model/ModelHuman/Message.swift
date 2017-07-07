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
    
    static let typeString = "type"
    
    static let twilioMessageIndex = "twilioMessageIndex"
    
	static let lastSizeString = "lastSizeString"
	static let showTypingString = "showTypingString"
    
    static let quickActions = "quick_actions"
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
open class Message: _Message, ImportableUniqueObject {

    /// Message type
    var type: AttributeType {
        /// Returns undefined if new type
        return AttributeType(rawValue: typeString ?? "") ?? .undefined
    }
    
    /// Attributes
    var attributes: [String: Any] {
        return attributes_ as? [String: Any] ?? [:]
    }
    
    /// Attributes converted to JSON
    private var attributesJSON: JSON {
        return JSON(attributes)
    }
    
    // MARK: - Quick actions
    var quickActions: [QuickAction] {
        
        /// Safety check
        guard let quickActionsArray = attributesJSON[MessageJSON.quickActions].array else {
            return []
        }
     
        /// Map & create actions
        return quickActionsArray.flatMap { QuickAction(attributes: $0) }
    }
    
    
    // MARK: - Importable Source Protocol
    public typealias ImportSource = (message: TCHMessage, channelID: String)
    
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
    public static func shouldUpdate(from source: (message: TCHMessage, channelID: String), in transaction: BaseDataTransaction) -> Bool {
        return true
    }
    
    public static func uniqueID(from source: (message: TCHMessage, channelID: String), in transaction: BaseDataTransaction) throws -> String? {
        return source.message.sid
    }
    
    // Unique ID value
    public static func shouldInsert(from source: (message: TCHMessage, channelID: String), in transaction: BaseDataTransaction) -> Bool {
        
        guard let id = source.message.sid else {
            return false
        }
        
        let object = transaction.fetchOne(From<Message>(),
                                          Where("\(ModelJSON.id) == %@", id))
        
        return object == nil
    }
    
    public func update(from source: (message: TCHMessage, channelID: String), in transaction: BaseDataTransaction) throws {
        try updateModel(with: source, transaction: transaction)
    }
    
    // New object created
    public func didInsert(from source: (message: TCHMessage, channelID: String), channelID: String, in transaction: BaseDataTransaction) throws {
        try updateModel(with: source, transaction: transaction)
    }
    
    public func updateFromImportSource(_ source: (message: TCHMessage, channelID: String), inTransaction transaction: BaseDataTransaction) throws {
        try updateModel(with: source, transaction: transaction)
    }
    
    func updateModel(with source: (message: TCHMessage, channelID: String), transaction: BaseDataTransaction) throws {
        
        /// ChannelID
        channel = source.channelID
        
        // ID
        id = source.message.sid

        /// Attribtes
        attributes_ = source.message.attributes()
        
        /// Author
        author = source.message.author
        
        /// Body
        body = source.message.body
        
        /// Sent Date
        sent = source.message.timestampAsDate
        
        /// Twillio index
        twilioMessageIndex = source.message.index
        
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
