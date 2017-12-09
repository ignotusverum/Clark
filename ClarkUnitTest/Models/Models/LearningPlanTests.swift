//
//  LearningPlanTests.swift
//  ClarkUnitTest
//
//  Created by Vladislav Zagorodnyuk on 10/25/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import XCTest
import CoreStore
import PromiseKit
import SwiftyJSON
import EZSwiftExtensions

class LearningPlanTests: XCTestCase {

    // MARK: - Expectations
    func testExpectations() {
        let _ = createLearningPlansInDatabase().then { response-> Void in
         
            XCTAssertEqual(response!.expectationsModel.tutor, "Test")
            XCTAssertEqual(response!.expectationsModel.session, "Test")
            XCTAssertEqual(response!.expectationsModel.student, "Test")
        }
    }
    
    // MARK: - Initialization tests
    func testInitFromJSON() {
        
        /// Test initialization
        let _ = createLearningPlansInDatabase().then { response-> Void in
            
            XCTAssertEqual(response!.objectives, "Test")
            XCTAssertEqual(response!.engagementLength, 5)
            XCTAssertEqual(response!.pastProgress, "Test")
            XCTAssertEqual(response!.expectedOutsideWorkInHours, 5)
            XCTAssertEqual(response!.expectedOutsideWorkType, "Test")
            XCTAssertEqual(response!.expectedOutsideWorkPerInterval, 5)
        }
    }
    
    // MARK: - Utilities
    func createLearningPlansInDatabase()-> Promise<LearningPlan?> {
        
        /// Test data
        let dictionary: [String: Any] = [
            "links": [
                "self": "https://manager-qa.hiclark.com/api/mobile/v1/learning_plans/380376ea-e4b0-44d9-8dab-2698424adaab"
            ],
            "type": "learning_plans",
            "id": "380376ea-e4b0-44d9-8dab-2698424adaab",
            ModelJSON.attributes: [
                LearningPlanJSON.objectives: "Test",
                LearningPlanJSON.engagementLength: 5,
                LearningPlanJSON.pastProgress: "Test",
                LearningPlanJSON.expectedOutsideWorkInHours: 5,
                LearningPlanJSON.expectedOutsideWorkType: "Test",
                LearningPlanJSON.expectedOutsideWorkPerInterval: 5,
                LearningPlanJSON.expectations: [ExpectationsJSON.session: "Test", ExpectationsJSON.tutor: "Test", ExpectationsJSON.student: "Test"]
            ]
        ]
        
        /// JSON
        let json: JSON = JSON(dictionary)
        return DatabaseManager.insertSync(Into<LearningPlan>(), source: json).then { response-> Promise<LearningPlan?> in
            /// Fetch db object
            return DatabaseManager.fetchExisting(response)
        }
    }
}
