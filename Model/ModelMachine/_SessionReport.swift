// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SessionReport.swift instead.

import Foundation
import CoreData

public enum SessionReportAttributes: String {
    case body = "body"
    case negativeNotes = "negativeNotes"
    case positiveNotes = "positiveNotes"
    case rating = "rating"
}

public enum SessionReportRelationships: String {
    case improvementDimentions = "improvementDimentions"
    case recursionDimentions = "recursionDimentions"
    case session = "session"
}

open class _SessionReport: Model {

    // MARK: - Class methods

    override open class func entityName () -> String {
        return "SessionReport"
    }

    override open class func entity(managedObjectContext: NSManagedObjectContext) -> NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: self.entityName(), in: managedObjectContext)
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public convenience init?(managedObjectContext: NSManagedObjectContext) {
        guard let entity = _SessionReport.entity(managedObjectContext: managedObjectContext) else { return nil }
        self.init(entity: entity, insertInto: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged open
    var body: String?

    @NSManaged open
    var negativeNotes: String?

    @NSManaged open
    var positiveNotes: String?

    @NSManaged open
    var rating: String?

    // MARK: - Relationships

    @NSManaged open
    var improvementDimentions: NSSet

    open func improvementDimentionsSet() -> NSMutableSet {
        return self.improvementDimentions.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var recursionDimentions: NSSet

    open func recursionDimentionsSet() -> NSMutableSet {
        return self.recursionDimentions.mutableCopy() as! NSMutableSet
    }

    @NSManaged open
    var session: Session?

}

extension _SessionReport {

    open func addImprovementDimentions(_ objects: NSSet) {
        let mutable = self.improvementDimentions.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.improvementDimentions = mutable.copy() as! NSSet
    }

    open func removeImprovementDimentions(_ objects: NSSet) {
        let mutable = self.improvementDimentions.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.improvementDimentions = mutable.copy() as! NSSet
    }

    open func addImprovementDimentionsObject(_ value: ProgressDimention) {
        let mutable = self.improvementDimentions.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.improvementDimentions = mutable.copy() as! NSSet
    }

    open func removeImprovementDimentionsObject(_ value: ProgressDimention) {
        let mutable = self.improvementDimentions.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.improvementDimentions = mutable.copy() as! NSSet
    }

}

extension _SessionReport {

    open func addRecursionDimentions(_ objects: NSSet) {
        let mutable = self.recursionDimentions.mutableCopy() as! NSMutableSet
        mutable.union(objects as Set<NSObject>)
        self.recursionDimentions = mutable.copy() as! NSSet
    }

    open func removeRecursionDimentions(_ objects: NSSet) {
        let mutable = self.recursionDimentions.mutableCopy() as! NSMutableSet
        mutable.minus(objects as Set<NSObject>)
        self.recursionDimentions = mutable.copy() as! NSSet
    }

    open func addRecursionDimentionsObject(_ value: ProgressDimention) {
        let mutable = self.recursionDimentions.mutableCopy() as! NSMutableSet
        mutable.add(value)
        self.recursionDimentions = mutable.copy() as! NSSet
    }

    open func removeRecursionDimentionsObject(_ value: ProgressDimention) {
        let mutable = self.recursionDimentions.mutableCopy() as! NSMutableSet
        mutable.remove(value)
        self.recursionDimentions = mutable.copy() as! NSSet
    }

}
