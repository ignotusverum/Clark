//
//  TutorTests.swift
//  ClarkUnitTest
//
//  Created by Vladislav Zagorodnyuk on 10/11/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import XCTest
import CoreStore
import PromiseKit
import SwiftyJSON
import EZSwiftExtensions

class TutorTests: XCTestCase {

    // MARK: - Initialization tests
    func testInitFromJSON() {
        
        /// Test initialization
        let _ = createTutorInDatabase().then { response-> Void in
            
            XCTAssertEqual(response!.lastName, "Zz")
            XCTAssertEqual(response!.firstName, "Vlad")
            XCTAssertEqual(response!.phone, "(646) 275-4512")
            XCTAssertEqual(response!.email, "test@hiclark.com")
            XCTAssertEqual(response!.bio, "Test test test test test")
            XCTAssertEqual(response!.defaultHourlyRateInCents, 90000)
            XCTAssertEqual(response!.pushNotificationsEnabled!.boolValue, true)
            XCTAssertEqual(response!.id, "164f950b-e1ce-4de3-8499-58c2fe8cd6b2")
        }
    }
    
    // MARK: - Utilities test
    /// Test full name
    func testFullName() {
        let _ = createTutorInDatabase().then { response-> Void in
            XCTAssertEqual(response!.fullName, "Vlad Zz")
        }
    }
    
    /// Test initials
    func testInitials() {
        let _ = createTutorInDatabase().then { response-> Void in
            XCTAssertEqual(response!.initials, "VZ")
            XCTAssertEqual(response!.lastNameInitial, "Z")
            XCTAssertEqual(response!.firstNameInitial, "V")
        }
    }
        
    // MARK: - Utilities
    func createTutorInDatabase()-> Promise<Tutor?> {
        
        /// Test data
        let dictionary: [String: Any] = [
            "links": [
                "self": "https://manager-qa.hiclark.com/api/mobile/v1/me"
            ],
            "type": "tutors",
            "id": "164f950b-e1ce-4de3-8499-58c2fe8cd6b2",
            ModelJSON.attributes: [
                TutorJSON.lastName: "Zz",
                TutorJSON.firstName: "Vlad",
                TutorJSON.phone: "6462754512",
                TutorJSON.email: "test@hiclark.com",
                TutorJSON.pushNotificationsEnabled: true,
                TutorJSON.bio: "Test test test test test",
                TutorJSON.defaultHourlyRateInCents: 90000,
                TutorJSON.defaultSessionLengthInMinutes: 60
            ]
        ]
        
        /// JSON
        let json: JSON = JSON(dictionary)
        
        return DatabaseManager.insertSync(Into<Tutor>(), source: json).then { response-> Promise<Tutor?> in
            /// Fetch db object
            return DatabaseManager.fetchExisting(response)
        }
    }
}
