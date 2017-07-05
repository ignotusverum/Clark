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
import JSQMessagesViewController

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
    static let privateAttributes = "privateAttributes"
    
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

@objc(Message)
open class Message: _Message {

    /// Attributes
    var attributes: [String: Any] {
        return attributes_ as? [String: Any] ?? [:]
    }
    
	/// Model update logic
    override func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {

        try super.updateModel(with: source, transaction: transaction)
        
        /// Attribtes
        attributes_ = source[MessageJSON.attributes].dictionaryObject
        privateAttributes_ = source[MessageJSON.privateAttributes].dictionaryObject
        
        /// Author
        author = source[MessageJSON.author].string ?? ""
        
        /// Blocking
        blocking = source[MessageJSON.blocking].number ?? NSNumber(value: false)
        
        /// Body
        body = source[MessageJSON.body].string ?? ""
        
        /// Channel
        channel = source[MessageJSON.channel].string
        
        /// Client decorations
        clientInputPlaceholderBody = source[MessageJSON.clientInputPlaceholderBody].string
        clientInputDecorationString = source[MessageJSON.clientInputDecorationString].string
        
        /// Form Id
        formID = source[MessageJSON.formID].string
        
        /// Image URL
        imageURL = source[MessageJSON.imageURL].string
        
        /// Last size
        lastSizeString = source[MessageJSON.lastSizeString].string
        
        /// Sent Date
        sent = source[MessageJSON.sent].dateTime
        
        /// Show Typing
        showTypingString = source[MessageJSON.showTypingString].string
        
        /// Twillio index
        twilioMessageIndex = source[MessageJSON.twilioMessageIndex].number
        
        /// Type
        typeString = source[MessageJSON.typeString].string
    }
}
