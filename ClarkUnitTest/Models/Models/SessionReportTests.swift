//
//  SessionReportTests.swift
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

class SessionReportTests: XCTestCase {
    
    // MARK: - Initialization tests
    func testInitFromJSON() {
        
        /// Test initialization
        let _ = createSubjectInDatabase().then { response-> Void in
            
            XCTAssertEqual(response!.body, "Testset")
            XCTAssertEqual(response!.negativeNotes, "Test")
            XCTAssertEqual(response!.positiveNotes, "Test")
            XCTAssertEqual(response!.rating, "It went well")
        }
    }
    
    // MARK: - Utilities
    func createSubjectInDatabase()-> Promise<SessionReport?> {
        
        /// Test data
        let dictionary: [String: Any] = [
            "links": [
                "self": "https://manager-qa.hiclark.com/api/mobile/v1/session_reports/3f2e4dee-b0c4-4ba0-af3d-4ba3b13ec6ef"
            ],
            "type": "session_reports",
            "id": "f807525c-0240-4762-9fba-05668c73737d",
            ModelJSON.attributes: [
                SessionReportJSON.body: "Testset",
                SessionReportJSON.negativeNotes: "Test",
                SessionReportJSON.positiveNotes: "Test",
                SessionReportJSON.rating: "It went well"
            ]
        ]
        
        /// JSON
        let json: JSON = JSON(dictionary)
        return DatabaseManager.insertSync(Into<SessionReport>(), source: json).then { response-> Promise<SessionReport?> in
            /// Fetch db object
            return DatabaseManager.fetchExisting(response)
        }
    }
}
