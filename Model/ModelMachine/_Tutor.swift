// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Tutor.swift instead.

import Foundation
import CoreData

public enum TutorAttributes: String {
    case bio = "bio"
    case defaultHourlyRateInCents = "defaultHourlyRateInCents"
    case defaultSessionLengthInMinutes = "defaultSessionLengthInMinutes"
    case email = "email"
    case firstName = "firstName"
    case imageURL = "imageURL"
    case lastName = "lastName"
    case phone = "phone"
    case preferredContactMethod = "preferredContactMethod"
    case pushNotificationsEnabled = "pushNotificationsEnabled"
    case subjectsTaught = "subjectsTaught"
}

public enum TutorRelationships: String {
    case sessions = "sessions"
    case students = "students"
    case subjects = "subjects"
}

open class _Tutor: Model {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "Tutor"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Tutor.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var bio: String?

    @NSManaged public
    var defaultHourlyRateInCents: NSNumber?

    @NSManaged public
    var defaultSessionLengthInMinutes: NSNumber?

    @NSManaged open
    var email: String?

    @NSManaged open
    var firstName: String?

    @NSManaged open
    var imageURL: String?

    @NSManaged open
    var lastName: String?

    @NSManaged open
    var phone: String?

    @NSManaged open
    var preferredContactMethod: String?

    @NSManaged public
    var pushNotificationsEnabled: NSNumber?

    @NSManaged open
    var subjectsTaught: String?

    // MARK: - Relationships

    @NSManaged open
    var sessions: NSSet

    open func sessionsSet() -> NSMutableSet {
        return self.sessions.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var students: NSSet

    open func studentsSet() -> NSMutableSet {
        return self.students.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var subjects: NSSet

    open func subjectsSet() -> NSMutableSet {
        return self.subjects.mutableCopy() as! NSMutableSet
    }

}

extension _Tutor {

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

extension _Tutor {

    open func addStudents(_ objects: NSSet) {
        let mutable = self.students.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.students = mutable.copy() as! NSSet
    }

    open func removeStudents(_ objects: NSSet) {
        let mutable = self.students.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.students = mutable.copy() as! NSSet
    }

    open func addStudentsObject(_ value: Student) {
        let mutable = self.students.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.students = mutable.copy() as! NSSet
    }

    open func removeStudentsObject(_ value: Student) {
        let mutable = self.students.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.students = mutable.copy() as! NSSet
    }

}

extension _Tutor {

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
