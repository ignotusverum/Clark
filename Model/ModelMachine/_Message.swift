// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Message.swift instead.

import Foundation
import CoreData

public enum MessageAttributes: String {
    case attributes_ = "attributes_"
    case author = "author"
    case blocking = "blocking"
    case body = "body"
    case channel = "channel"
    case clientInputDecorationString = "clientInputDecorationString"
    case clientInputPlaceholderBody = "clientInputPlaceholderBody"
    case formID = "formID"
    case id = "id"
    case imageURL = "imageURL"
    case lastSizeString = "lastSizeString"
    case privateAttributes_ = "privateAttributes_"
    case sent = "sent"
    case showTypingString = "showTypingString"
    case twilioMessageIndex = "twilioMessageIndex"
    case typeString = "typeString"
}

open class _Message: NSManagedObject {

    // MARK: - Class methods

    open class func entityName () -> String {
        return "Message"
    }

    open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Message.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var attributes_: Any?

    @NSManaged open
    var author: String!

    @NSManaged public
    var blocking: NSNumber?

    @NSManaged open
    var body: String!

    @NSManaged open
    var channel: String?

    @NSManaged open
    var clientInputDecorationString: String?

    @NSManaged open
    var clientInputPlaceholderBody: String?

    @NSManaged open
    var formID: String?

    @NSManaged open
    var id: String?

    @NSManaged open
    var imageURL: String?

    @NSManaged open
    var lastSizeString: String?

    @NSManaged public
    var privateAttributes_: Any?

    @NSManaged open
    var sent: Date?

    @NSManaged open
    var showTypingString: String?

    @NSManaged public
    var twilioMessageIndex: NSNumber?

    @NSManaged open
    var typeString: String?

    // MARK: - Relationships

}

