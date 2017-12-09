// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Student.swift instead.

import Foundation
import CoreData

public enum StudentAttributes: String {
    case age = "age"
    case cancelationTypeString = "cancelationTypeString"
    case cancellationPercentageCharged = "cancellationPercentageCharged"
    case cancellationWindowInHours = "cancellationWindowInHours"
    case defaultHourlyRateInCents = "defaultHourlyRateInCents"
    case defaultSessionLengthInMinutes = "defaultSessionLengthInMinutes"
    case email = "email"
    case firstName = "firstName"
    case fullName = "fullName"
    case gender = "gender"
    case lastName = "lastName"
    case nextUpcomingSessionDate = "nextUpcomingSessionDate"
    case phone = "phone"
    case status = "status"
}

public enum StudentRelationships: String {
    case closestSession = "closestSession"
    case learningPlans = "learningPlans"
    case proxy = "proxy"
    case sessions = "sessions"
    case subjects = "subjects"
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

    @NSManaged open
    var cancelationTypeString: String?

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
    var fullName: String?

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
    var closestSession: Session?

    @NSManaged open
    var learningPlans: NSSet

    open func learningPlansSet() -> NSMutableSet {
        return self.learningPlans.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var proxy: Proxy?

    @NSManaged open
    var sessions: NSSet

    open func sessionsSet() -> NSMutableSet {
        return self.sessions.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var subjects: NSSet

    open func subjectsSet() -> NSMutableSet {
        return self.subjects.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var tutor: Tutor?

}

extension _Student {

    open func addLearningPlans(_ objects: NSSet) {
        let mutable = self.learningPlans.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.learningPlans = mutable.copy() as! NSSet
    }

    open func removeLearningPlans(_ objects: NSSet) {
        let mutable = self.learningPlans.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.learningPlans = mutable.copy() as! NSSet
    }

    open func addLearningPlansObject(_ value: LearningPlan) {
        let mutable = self.learningPlans.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.learningPlans = mutable.copy() as! NSSet
    }

    open func removeLearningPlansObject(_ value: LearningPlan) {
        let mutable = self.learningPlans.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.learningPlans = mutable.copy() as! NSSet
    }

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

extension _Student {

    open func addSubjects(_ objects: NSSet) {
        let mutable = self.subjects.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.subjects = mutable.copy() as! NSSet
    }

    open func removeSubjects(_ objects: NSSet) {
        let mutable = self.subjects.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.subjects = mutable.copy() as! NSSet
    }

    open func addSubjectsObject(_ value: Subject) {
        let mutable = self.subjects.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.subjects = mutable.copy() as! NSSet
    }

    open func removeSubjectsObject(_ value: Subject) {
        let mutable = self.subjects.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.subjects = mutable.copy() as! NSSet
    }

}
