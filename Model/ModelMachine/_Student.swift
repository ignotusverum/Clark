// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Student.swift instead.

import Foundation
import CoreData

public enum StudentAttributes: String {
    case age = "age"
    case cancellationPercentageCharged = "cancellationPercentageCharged"
    case cancellationWindowInHours = "cancellationWindowInHours"
    case defaultHourlyRateInCents = "defaultHourlyRateInCents"
    case defaultSessionLengthInMinutes = "defaultSessionLengthInMinutes"
    case email = "email"
    case firstName = "firstName"
    case gender = "gender"
    case lastName = "lastName"
    case nextUpcomingSessionDate = "nextUpcomingSessionDate"
    case phone = "phone"
    case status = "status"
}

public enum StudentRelationships: String {
    case sessions = "sessions"
    case tutor = "tutor"
}

open class _Student: Model {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "Student"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Student.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var age: NSNumber?

    @NSManaged public
    var cancellationPercentageCharged: NSNumber?

    @NSManaged public
    var cancellationWindowInHours: NSNumber?

    @NSManaged public
    var defaultHourlyRateInCents: NSNumber?

    @NSManaged public
    var defaultSessionLengthInMinutes: NSNumber?

    @NSManaged open
    var email: String?

    @NSManaged open
    var firstName: String?

    @NSManaged open
    var gender: String?

    @NSManaged open
    var lastName: String?

    @NSManaged open
    var nextUpcomingSessionDate: Date?

    @NSManaged open
    var phone: String?

    @NSManaged open
    var status: String?

    // MARK: - Relationships

    @NSManaged open
    var sessions: NSSet

    open func sessionsSet() -> NSMutableSet {
        return self.sessions.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var tutor: Tutor?

}

extension _Student {

    open func addSessions(_ objects: NSSet) {
        let mutable = self.sessions.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.sessions = mutable.copy() as! NSSet
    }

    open func removeSessions(_ objects: NSSet) {
        let mutable = self.sessions.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.sessions = mutable.copy() as! NSSet
    }

    open func addSessionsObject(_ value: Session) {
        let mutable = self.sessions.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.sessions = mutable.copy() as! NSSet
    }

    open func removeSessionsObject(_ value: Session) {
        let mutable = self.sessions.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.sessions = mutable.copy() as! NSSet
    }

}
