//
//  CopeTests.swift
//  ClarkUnitTest
//
//  Created by Vladislav Zagorodnyuk on 10/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import XCTest
import CoreStore
import PromiseKit
import SwiftyJSON
import EZSwiftExtensions

class CopyTests: XCTestCase {
    
    /// Test session time
    func testSessionTime() {
        let _ = createSessionInDatabase().then { response-> Void in
            XCTAssertEqual(Copy.sessionTime(session: response!), "11:04 AM • 1 hour")
        }
    }
    
    /// Test session date
    func testSessionDate() {
        let _ = createSessionInDatabase().then { response-> Void in
            XCTAssertEqual(Copy.sessionDate(session: response!), "Wed, Oct 11")
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
                SessionJSON.endTime: "2017-10-11 15:04:15 +0000",
                SessionJSON.startTime: "2017-10-11 15:04:15 +0000"
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
