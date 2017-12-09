// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LearningPlan.swift instead.

import Foundation
import CoreData

public enum LearningPlanAttributes: String {
    case engagementLength = "engagementLength"
    case engagementLengthUnit = "engagementLengthUnit"
    case expectations = "expectations"
    case expectedOutsideWorkInHours = "expectedOutsideWorkInHours"
    case expectedOutsideWorkPerInterval = "expectedOutsideWorkPerInterval"
    case expectedOutsideWorkType = "expectedOutsideWorkType"
    case objectives = "objectives"
    case pastProgress = "pastProgress"
}

public enum LearningPlanRelationships: String {
    case dimentions = "dimentions"
    case student = "student"
    case subjects = "subjects"
}

open class _LearningPlan: Model {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "LearningPlan"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _LearningPlan.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var engagementLength: NSNumber?

    @NSManaged open
    var engagementLengthUnit: String?

    @NSManaged public
    var expectations: Any?

    @NSManaged public
    var expectedOutsideWorkInHours: NSNumber?

    @NSManaged public
    var expectedOutsideWorkPerInterval: NSNumber?

    @NSManaged open
    var expectedOutsideWorkType: String?

    @NSManaged open
    var objectives: String?

    @NSManaged open
    var pastProgress: String?

    // MARK: - Relationships

    @NSManaged open
    var dimentions: NSSet

    open func dimentionsSet() -> NSMutableSet {
        return self.dimentions.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var student: Student?

    @NSManaged open
    var subjects: Subject?

}

extension _LearningPlan {

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
