//
//  StudentTest.swift
//  ClarkUnitTest
//
//  Created by Vladislav Zagorodnyuk on 10/24/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import XCTest
import CoreStore
import PromiseKit
import SwiftyJSON
import EZSwiftExtensions

class StudentTest: XCTestCase {

    /// Body test
    func bodyTest() {
        let _ = createStudentInDatabase().then { response-> Void in
            XCTAssertEqual(response!.fullName, "Test Test")
        }
    }
    
    /// Test fee string
    func testFeeString() {
        let _ = createStudentInDatabase().then { response-> Void in
            XCTAssertEqual(response!.feeString, "$555")
        }
    }
    
    /// Test fee
    func testFee() {
        let _ = createStudentInDatabase().then { response-> Void in
            XCTAssertEqual(response!.fee, 555)
        }
    }
    
    /// Cancelation type
    func testCancelationType() {
        let _ = createStudentInDatabase().then { response-> Void in
            XCTAssertEqual(response!.cancelationTypeString, "moderate")
            XCTAssertEqual(response!.cancelationType, .moderate)
        }
    }

    /// First name initial
    func testFirstNameInitial() {
        let _ = createStudentInDatabase().then { response-> Void in
            XCTAssertEqual(response!.firstNameInitial, "T")
        }
    }
    
    /// First last initial
    func testLastNameInitial() {
        let _ = createStudentInDatabase().then { response-> Void in
            XCTAssertEqual(response!.lastNameInitial, "T")
        }
    }
    
    /// Initial
    func testInitials() {
        let _ = createStudentInDatabase().then { response-> Void in
            XCTAssertEqual(response!.initials, "TT")
        }
    }
    
    /// Phones
    func testPhones() {
        let _ = createStudentInDatabase().then { response-> Void in
            XCTAssertEqual(response!.phone, "16462754512")
        }
    }
    
    /// Gender
    func testGender() {
        let _ = createStudentInDatabase().then { response-> Void in
            XCTAssertEqual(response!.gender, "not given")
        }
    }
    
    /// Gender
    func testStatus() {
        let _ = createStudentInDatabase().then { response-> Void in
            XCTAssertEqual(response!.status, "active")
        }
    }
    
    // MARK: - Initialization tests
    func testInitFromJSON() {
        
        /// Test initialization
        let _ = createStudentInDatabase().then { response-> Void in
            
            XCTAssertEqual(response!.status, "active")
            XCTAssertEqual(response!.lastName, "Test")
            XCTAssertEqual(response!.firstName, "Test")
            XCTAssertEqual(response!.gender, "not given")
            XCTAssertEqual(response!.phone, "16462754512")
            XCTAssertEqual(response!.cancellationWindowInHours, 24)
            XCTAssertEqual(response!.cancellationPercentageCharged, 50)
            XCTAssertEqual(response!.cancelationTypeString, "moderate")
            XCTAssertEqual(response!.defaultSessionLengthInMinutes, 60)
            XCTAssertEqual(response!.defaultHourlyRateInCents, 55500)
        }
    }
    
    // MARK: - Utilities
    func createStudentInDatabase()-> Promise<Student?> {
        
        /// Test data
        let dictionary: [String: Any] = [
            "links": [
                "self": "https://manager-qa.hiclark.com/api/mobile/v1/students/04291950-b916-4a70-86a6-63f28e438dcd"
            ],
            "type": "students",
            "id": "04291950-b916-4a70-86a6-63f28e438dcd",
            ModelJSON.attributes: [
                StudentJSON.lastName: "Test",
                StudentJSON.status: "active",
                StudentJSON.firstName: "Test",
                StudentJSON.gender: "not given",
                StudentJSON.phone: "16462754512",
                StudentJSON.cancelation: "moderate",
                StudentJSON.cancellationWindowInHours: 24,
                StudentJSON.defaultHourlyRateInCents: 55500,
                StudentJSON.cancellationPercentageCharged: 50,
                StudentJSON.defaultSessionLengthInMinutes: 60
            ],
            ModelJSON.relationShips: [
                StudentJSON.session: [
                    ModelJSON.data: [
                        "type": "sessions",
                        ModelJSON.id: "3e3f22e7-bf44-440e-8386-a2b04e1c3fd8"
                    ]
                ]
            ]
        ]
        
        /// JSON
        let json: JSON = JSON(dictionary)
        return DatabaseManager.insertSync(Into<Student>(), source: json).then { response-> Promise<Student?> in
            /// Fetch db object
            return DatabaseManager.fetchExisting(response)
        }
    }
}
