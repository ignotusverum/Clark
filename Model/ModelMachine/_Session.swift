// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Session.swift instead.

import Foundation
import CoreData

public enum SessionAttributes: String {
    case durationInMinutes = "durationInMinutes"
    case endTime = "endTime"
    case feeInCents = "feeInCents"
    case feedbackReportBody = "feedbackReportBody"
    case location = "location"
    case startTime = "startTime"
    case statusString = "statusString"
}

public enum SessionRelationships: String {
    case student = "student"
    case tutor = "tutor"
}

open class _Session: Model {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "Session"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Session.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var durationInMinutes: NSNumber?

    @NSManaged open
    var endTime: Date!

    @NSManaged public
    var feeInCents: NSNumber?

    @NSManaged open
    var feedbackReportBody: String?

    @NSManaged open
    var location: String?

    @NSManaged open
    var startTime: Date!

    @NSManaged open
    var statusString: String?

    // MARK: - Relationships

    @NSManaged open
    var student: Student?

    @NSManaged open
    var tutor: Tutor?

}

