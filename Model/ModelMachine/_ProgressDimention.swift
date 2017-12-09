// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ProgressDimention.swift instead.

import Foundation
import CoreData

public enum ProgressDimentionAttributes: String {
    case category = "category"
    case dimentionDescription = "dimentionDescription"
    case name = "name"
}

public enum ProgressDimentionRelationships: String {
    case learningPlan = "learningPlan"
    case sessionReportImprovement = "sessionReportImprovement"
    case sessionReportRecursion = "sessionReportRecursion"
    case subject = "subject"
}

open class _ProgressDimention: Model {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "ProgressDimention"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _ProgressDimention.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var category: String?

    @NSManaged public
    var dimentionDescription: Any?

    @NSManaged open
    var name: String?

    // MARK: - Relationships

    @NSManaged open
    var learningPlan: NSSet

    open func learningPlanSet() -> NSMutableSet {
        return self.learningPlan.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var sessionReportImprovement: NSSet

    open func sessionReportImprovementSet() -> NSMutableSet {
        return self.sessionReportImprovement.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var sessionReportRecursion: NSSet

    open func sessionReportRecursionSet() -> NSMutableSet {
        return self.sessionReportRecursion.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var subject: Subject?

}

extension _ProgressDimention {

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

extension _ProgressDimention {

    open func addSessionReportImprovement(_ objects: NSSet) {
        let mutable = self.sessionReportImprovement.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.sessionReportImprovement = mutable.copy() as! NSSet
    }

    open func removeSessionReportImprovement(_ objects: NSSet) {
        let mutable = self.sessionReportImprovement.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.sessionReportImprovement = mutable.copy() as! NSSet
    }

    open func addSessionReportImprovementObject(_ value: SessionReport) {
        let mutable = self.sessionReportImprovement.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.sessionReportImprovement = mutable.copy() as! NSSet
    }

    open func removeSessionReportImprovementObject(_ value: SessionReport) {
        let mutable = self.sessionReportImprovement.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.sessionReportImprovement = mutable.copy() as! NSSet
    }

}

extension _ProgressDimention {

    open func addSessionReportRecursion(_ objects: NSSet) {
        let mutable = self.sessionReportRecursion.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.sessionReportRecursion = mutable.copy() as! NSSet
    }

    open func removeSessionReportRecursion(_ objects: NSSet) {
        let mutable = self.sessionReportRecursion.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.sessionReportRecursion = mutable.copy() as! NSSet
    }

    open func addSessionReportRecursionObject(_ value: SessionReport) {
        let mutable = self.sessionReportRecursion.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.sessionReportRecursion = mutable.copy() as! NSSet
    }

    open func removeSessionReportRecursionObject(_ value: SessionReport) {
        let mutable = self.sessionReportRecursion.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.sessionReportRecursion = mutable.copy() as! NSSet
    }

}
