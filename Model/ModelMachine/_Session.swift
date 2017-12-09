// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Session.swift instead.

import Foundation
import CoreData

public enum SessionAttributes: String {
    case durationInMinutes = "durationInMinutes"
    case endTime = "endTime"
    case feeInCents = "feeInCents"
    case feedbackBody = "feedbackBody"
    case feedbackNegative = "feedbackNegative"
    case feedbackPositive = "feedbackPositive"
    case feedbackRating = "feedbackRating"
    case isRemindersOn = "isRemindersOn"
    case location = "location"
    case orderingDate = "orderingDate"
    case startTime = "startTime"
    case statusString = "statusString"
    case studentDetailsOrdering = "studentDetailsOrdering"
}

public enum SessionRelationships: String {
    case closestStudent = "closestStudent"
    case sessionReport = "sessionReport"
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
    var endTime: Date?

    @NSManaged public
    var feeInCents: NSNumber?

    @NSManaged open
    var feedbackBody: String?

    @NSManaged open
    var feedbackNegative: String?

    @NSManaged open
    var feedbackPositive: String?

    @NSManaged open
    var feedbackRating: String?

    @NSManaged public
    var isRemindersOn: NSNumber?

    @NSManaged open
    var location: String?

    @NSManaged open
    var orderingDate: Date?

    @NSManaged open
    var startTime: Date?

    @NSManaged open
    var statusString: String?

    @NSManaged public
    var studentDetailsOrdering: NSNumber?

    // MARK: - Relationships

    @NSManaged open
    var closestStudent: Student?

    @NSManaged open
    var sessionReport: SessionReport?

    @NSManaged open
    var student: Student?

    @NSManaged open
    var tutor: Tutor?

}

