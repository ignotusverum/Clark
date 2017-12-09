//
//  SessionsTest.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 10/24/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import XCTest
import CoreStore
import PromiseKit
import SwiftyJSON
import EZSwiftExtensions

class SessionsTest: XCTestCase {

    /// Test fee string
    func testFeeString() {
        let _ = createSessionInDatabase().then { response-> Void in
            XCTAssertEqual(response!.feeString, "$416")
        }
    }
    
    /// Test fee
    func testFee() {
        let _ = createSessionInDatabase().then { response-> Void in
            XCTAssertEqual(response!.fee, 416)
        }
    }
    
    /// Test status
    func testStatus() {
        let _ = createSessionInDatabase().then { response-> Void in
            XCTAssertEqual(response!.status, .pending)
        }
    }
    
    /// Test positive feedback
    func testFeedbackPositive() {
        let _ = createSessionInDatabase().then { response-> Void in
            XCTAssertEqual(response!.hasFeedbackPositive, true)
        }
    }
    
    /// Test negative feedback
    func testFeedbackNegative() {
        let _ = createSessionInDatabase().then { response-> Void in
            XCTAssertEqual(response!.hasFeedbackNegative, true)
        }
    }
    
    /// Test Month
    func testMonth() {
        let _ = createSessionInDatabase().then { response-> Void in
            XCTAssertEqual(response!.headerString, "Oct")
        }
    }
    
    /// Test Autocomplete
    func testAutocomplete() {
        let _ = createSessionInDatabase().then { response-> Void in
            XCTAssertEqual(response!.body, "")
        }
    }
    
    // MARK: - Initialization tests
    func testInitFromJSON() {
        
        /// Test initialization
        let _ = createSessionInDatabase().then { response-> Void in
            
            XCTAssertNotNil(response!.student)
            XCTAssertEqual(response!.feeInCents, 41625)
            XCTAssertEqual(response!.feedbackNegative, "")
            XCTAssertEqual(response!.durationInMinutes, 45)
            XCTAssertEqual(response!.statusString, "pending")
            XCTAssertEqual(response!.endTime, JSONFormatter.jsonDateTimeFormatter.date(from: "2017-10-26T06:45:00 +0000"))
            XCTAssertEqual(response!.startTime, JSONFormatter.jsonDateTimeFormatter.date(from: "2017-10-26T06:00:00 +0000"))
        }
    }
    
    // MARK: - Utilities
    func createSessionInDatabase()-> Promise<Session?> {
        
        /// Test data
        let dictionary: [String: Any] = [
            "links": [
                "self": "https://manager-qa.hiclark.com/api/mobile/v1/sessions/3e3f22e7-bf44-440e-8386-a2b04e1c3fd8"
            ],
            "type": "sessions",
            "id": "3e3f22e7-bf44-440e-8386-a2b04e1c3fd8",
            ModelJSON.attributes: [
                SessionJSON.feeInCents: 41625,
                SessionJSON.durationInMinutes: 45,
                SessionJSON.feedbackRating: "test",
                SessionJSON.statusString: "pending",
                SessionJSON.feedbackNegative: "test",
                SessionJSON.endTime: "2017-10-26T06:45:00 +0000",
                SessionJSON.startTime: "2017-10-26T06:00:00 +0000",
            ],
            ModelJSON.relationShips: [
                SessionJSON.student: [
                    ModelJSON.data: [
                        "type": "string",
                        ModelJSON.id: "04291950-b916-4a70-86a6-63f28e438dcd"
                    ]
                ]
            ]
        ]
        
        /// JSON
        let json: JSON = JSON(dictionary)
        
        return DatabaseManager.insertSync(Into<Session>(), source: json).then { response-> Promise<Session?> in
            /// Fetch db object
            return DatabaseManager.fetchExisting(response)
        }
    }
}
