//
//  LearningPlan.swift
//  GateKeeper
//
//  Created by Vladislav Zagorodnyuk on 10/02/16.
//  Copyright © 2016 Vladislav Zagorodnyuk Co. All rights reserved.
//

import CoreStore
import SwiftyJSON
import PromiseKit

/// Struct that represent LearningPlan JSON keys
public struct LearningPlanJSON {

    static let objectives = "objectives"
    static let pastProgress = "past_progress"
    
	static let engagementLength = "engagement_length"
	static let engagementLengthUnit = "engagement_length_unit"
    
    static let expectedOutsideWorkType = "expected_outside_work_type"
	static let expectedOutsideWorkInHours = "expected_outside_work_in_hours"
    static let expectedOutsideWorkPerInterval = "expected_outside_work_per_interval"
    
    static let expectations = "engagement_expectations"
}

public struct ExpectationsJSON {
    static let student = "student_expectations"
    static let session = "session_expectations"
    static let tutor = "tutor_expectations"
}

struct Expectations {
    var student: String?
    var session: String?
    var tutor: String?
    
    init(source: JSON) {
        
        /// Student
        student = source[ExpectationsJSON.student].string
        
        /// Session
        session = source[ExpectationsJSON.session].string
        
        /// Tutor
        tutor = source[ExpectationsJSON.tutor].string
    }
}

@objc(LearningPlan)
open class LearningPlan: _LearningPlan {

    /// Expectations
    var expectationsModel: Expectations {
        return Expectations(source: expectations as? JSON ?? JSON.null)
    }
    
    /// Dimensions array
    var dimensionsArray: [ProgressDimention] {
        return dimentions.allObjects as? [ProgressDimention] ?? []
    }
    
	/// Model update logic
    override func updateModel(with source: JSON, transaction: BaseDataTransaction) throws {

        try super.updateModel(with: source, transaction: transaction)
        
        /// Safety check for attributes
        guard let attributesJSON = source[ModelJSON.attributes].json else {
            return
        }
        
        /// Objectives
        objectives = attributesJSON[LearningPlanJSON.objectives].string
        
        /// Past progress
        pastProgress = attributesJSON[LearningPlanJSON.pastProgress].string
        
        /// Engagement length
        engagementLength = attributesJSON[LearningPlanJSON.pastProgress].number
        
        /// Engagement unit
        engagementLengthUnit = attributesJSON[LearningPlanJSON.pastProgress].string
        
        /// Expected ouside work hours
        expectedOutsideWorkInHours = attributesJSON[LearningPlanJSON.expectedOutsideWorkInHours].number
        
        /// Expected ouside work hours
        expectedOutsideWorkPerInterval = attributesJSON[LearningPlanJSON.expectedOutsideWorkInHours].number
        
        /// Expectations
        expectations = attributesJSON[LearningPlanJSON.expectations].dictionaryObject
    }
}
