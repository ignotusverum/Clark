//
//  ProgressDimensionsTests.swift
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

class ProgressDimensionsTests: XCTestCase {

    // MARK: - Initialization tests
    func testInitFromJSON() {
        
        /// Test initialization
        let _ = createProgressDimensionsInDatabase().then { response-> Void in
            
            XCTAssertEqual(response!.name, "Behavior")
            XCTAssertEqual(response!.category, "SEL")
            XCTAssertEqual(response!.descriptions, ["Student acted respectfully throughout the lesson", "Student responded well to failure."])
        }
    }
    
    // MARK: - Utilities
    func createProgressDimensionsInDatabase()-> Promise<ProgressDimention?> {
        
        /// Test data
        let dictionary: [String: Any] = [
            "links": [
                "self": "https://manager-qa.hiclark.com/api/mobile/v1/session_reports/3f2e4dee-b0c4-4ba0-af3d-4ba3b13ec6ef"
            ],
            "type": "progress_dimensions",
            "id": "074cfb3c-06f7-4ad1-9cd7-5d6b50e065bf",
            ModelJSON.attributes: [
                ProgressDimentionJSON.name: "Behavior",
                ProgressDimentionJSON.category: "SEL",
                ProgressDimentionJSON.dimentionDescription: ["Student acted respectfully throughout the lesson", "Student responded well to failure."]
            ]
        ]
        
        /// JSON
        let json: JSON = JSON(dictionary)
        return DatabaseManager.insertSync(Into<ProgressDimention>(), source: json).then { response-> Promise<ProgressDimention?> in
            /// Fetch db object
            return DatabaseManager.fetchExisting(response)
        }
    }
}
