// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Subject.swift instead.

import Foundation
import CoreData

public enum SubjectAttributes: String {
    case category = "category"
    case name = "name"
    case typeString = "typeString"
}

public enum SubjectRelationships: String {
    case dimentions = "dimentions"
    case learningPlan = "learningPlan"
    case student = "student"
    case tutor = "tutor"
}

open class _Subject: Model {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "Subject"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _Subject.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var category: String?

    @NSManaged open
    var name: String?

    @NSManaged open
    var typeString: String?

    // MARK: - Relationships

    @NSManaged open
    var dimentions: NSSet

    open func dimentionsSet() -> NSMutableSet {
        return self.dimentions.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var learningPlan: NSSet

    open func learningPlanSet() -> NSMutableSet {
        return self.learningPlan.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var student: NSSet

    open func studentSet() -> NSMutableSet {
        return self.student.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var tutor: Tutor?

}

extension _Subject {

    open func addDimentions(_ objects: NSSet) {
        let mutable = self.dimentions.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.dimentions = mutable.copy() as! NSSet
    }

    open func removeDimentions(_ objects: NSSet) {
        let mutable = self.dimentions.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.dimentions = mutable.copy() as! NSSet
    }

    open func addDimentionsObject(_ value: ProgressDimention) {
        let mutable = self.dimentions.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.dimentions = mutable.copy() as! NSSet
    }

    open func removeDimentionsObject(_ value: ProgressDimention) {
        let mutable = self.dimentions.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.dimentions = mutable.copy() as! NSSet
    }

}

extension _Subject {

    open func addLearningPlan(_ objects: NSSet) {
        let mutable = self.learningPlan.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.learningPlan = mutable.copy() as! NSSet
    }

    open func removeLearningPlan(_ objects: NSSet) {
        let mutable = self.learningPlan.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.learningPlan = mutable.copy() as! NSSet
    }

    open func addLearningPlanObject(_ value: LearningPlan) {
        let mutable = self.learningPlan.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.learningPlan = mutable.copy() as! NSSet
    }

    open func removeLearningPlanObject(_ value: LearningPlan) {
        let mutable = self.learningPlan.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.learningPlan = mutable.copy() as! NSSet
    }

}

extension _Subject {

    open func addStudent(_ objects: NSSet) {
        let mutable = self.student.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.student = mutable.copy() as! NSSet
    }

    open func removeStudent(_ objects: NSSet) {
        let mutable = self.student.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.student = mutable.copy() as! NSSet
    }

    open func addStudentObject(_ value: Student) {
        let mutable = self.student.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.student = mutable.copy() as! NSSet
    }

    open func removeStudentObject(_ value: Student) {
        let mutable = self.student.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.student = mutable.copy() as! NSSet
    }

}
