// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Proxy.swift instead.

import Foundation
import CoreData

public enum ProxyAttributes: String {
    case email = "email"
    case firstName = "firstName"
    case lastName = "lastName"
    case phone = "phone"
}

public enum ProxyRelationships: String {
    case student = "student"
}

open class _Proxy: Model {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "Proxy"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Proxy.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var email: String?

    @NSManaged open
    var firstName: String?

    @NSManaged open
    var lastName: String?

    @NSManaged open
    var phone: String?

    // MARK: - Relationships

    @NSManaged open
    var student: Student?

}

