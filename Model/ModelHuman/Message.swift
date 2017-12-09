//
//  Message.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import Kanna
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
    
    static let formID = "form_id"
    
    static let body = "body"
    static let author = "author"
    static let channel = "channel"
    static let imageURL = "image_url"
    
    static let blocking = "blocking"
    static let clientInputPlaceholderBody = "clientInputPlaceholderBody"
    static let clientInputDecorationString = "clientInputDecorationString"
    
    static let sent = "sent"
    
    static let typeString = "type"
    
    static let twilioMessageIndex = "twilioMessageIndex"
    
    static let lastSizeString = "lastSizeString"
    static let showTypingString = "showTypingString"
    
    static let carousel = "carousel_items"
    static let quickActions = "quick_actions"
    static let quickReplies = "quick_replies"
    
    static let htmlBody = "html_body"
    static let responseAttributes = "response_attributes"
    static let stripeMetadata = "stripe_metadata"
    
    static let destination = "app_destination"
}

/// Message type
enum AttributeType: String {
    case text = "text"
    case html = "html"
    case card = "card"
    case image = "image"
    case timer = "timer"
    case emoji = "emoji"
    case carousel = "carousel"
    case errorText = "text_error"
    case formInput = "form_inputs"
    case cardAction = "card_action"
    
    case undefined
}

@objc(Message)
open class Message: _Message, ImportableUniqueObject {
    
    /// Message type
    var type: AttributeType {
        /// Returns undefined if new type
        return AttributeType(rawValue: typeString ?? "") ?? .undefined
    }
    
    /// Image URL
    var image: URL? {
        return URL(string: imageURL ?? "")
    }
    
    /// Attributes
    var attributes: [String: Any] {
        set {
            attributes_ = newValue
        }
        get {
            return attributes_ as? [String: Any] ?? [:]
        }
    }
    
    var responseAttributes: [String: Any] {
        
        set {
            responseAttributes_ = newValue
        }
        get {
            return responseAttributes_ as? [String: Any] ?? [:]
        }
    }
    
    var responseAttributesJSON: JSON {
        return JSON(responseAttributes)
    }
    
    /// Attributes converted to JSON
    var attributesJSON: JSON {
        return JSON(attributes)
    }
    
    // MARK: - Input forms
    var formInputs: FormInputs? {
        return FormInputs(source: attributesJSON)
    }
    
    /// Should create ground
    var isShouldCreateGroup: Bool {
        return type == .carousel || type == .formInput || type == .image || type == .card
    }
    
    /// Should show message body
    var shouldShowMessageBody: Bool {
        return body.lowercased() != "form" && body.lowercased() != "preview image" && body.lowercased() != "student added card" && body.lowercased() != "session added card" && body.lowercased() != "learning plan added card"
    }
    
    /// Form inputs to create
    var formInputToCreate: FormInputs? {
        return FormInputs(source: responseAttributesJSON)
    }
    
    // MARK: - Card message
    var cardCompleted: CardsCompleted? {
        return CardsCompleted(source: attributesJSON)
    }
    
    // MARK: - Stripe info
    var stripeInfo: StripeInfo? {
        
        /// Safety check
        guard let stripeSource = attributesJSON[MessageJSON.stripeMetadata].json else {
            return nil
        }
        
        return StripeInfo(source: stripeSource)
    }
    
    // MARK: - Carousel
    var carousel: [CarouselItem] {
        
        /// Safety check
        guard let carouselItemsArray = attributesJSON[MessageJSON.carousel].array else {
            return []
        }
        
        /// Map & create carousels
        return carouselItemsArray.map { CarouselItem(source: $0) }
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
    
    // MARK: - Quick replies
    var quickReplies: [QuickReply] {
        
        /// Safety check
        guard let quickReplyArray = attributesJSON[MessageJSON.quickReplies].array else {
            return []
        }
        
        /// Map & Create replies
        return quickReplyArray.flatMap { QuickReply(source: $0) }
    }
    
    // MARK: - HTML body
    var htmlBody: NSAttributedString? {
        return attributesJSON[MessageJSON.htmlBody].string?.utf8Data?.attributedString
    }
    
    var htmlLink: URL? {
        
        /// Get html object
        guard let htmlString = attributesJSON[MessageJSON.htmlBody].string, let html = HTML(html: htmlString, encoding: .utf8) else {
            return nil
        }
        
        /// Find first link
        for link in html.xpath("//a | //link") {
            if let href = link["href"], let urlLink = URL(string: href) {
                
                return urlLink
            }
        }
        
        return nil
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
        let blockingNumber = attributesJSON[MessageJSON.blocking].number
        let blockingBool = attributesJSON[MessageJSON.blocking].string?.toBool() ?? false
        blocking = blockingNumber != nil ? blockingNumber! : NSNumber(value: blockingBool)
        
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
        
        /// Response attributes
        responseAttributes_ = attributesJSON[MessageJSON.responseAttributes].dictionaryObject
        
        /// Update type, if there's form inputs
        let tempTypeString = attributesJSON[MessageJSON.typeString].string
        typeString = formInputs == nil ? tempTypeString : FormInputsJSON.inputs
        
        /// Check if type is card action
        if let quickAction = attributesJSON[MessageJSON.quickActions].array, let first = quickAction.first, let _ = first[MessageJSON.destination].string {
            typeString = AttributeType.cardAction.rawValue
        }
    }
}

 
