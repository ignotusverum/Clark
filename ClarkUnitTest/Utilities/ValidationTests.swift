//
//  ValidationTests.swift
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

class ValidationTests: XCTestCase {

    /// Email validation test
    func testEmailValidation() {
        
        let test1 = Validation.isValidEmail("vlad@hiclark.com")
        let test2 = Validation.isValidEmail("vlad+test@hiclark.com")
        let test3 = Validation.isValidEmail("vlad+test...@hiclark.com")
        let test4 = Validation.isValidEmail("@@@hiclark.com")
        let test5 = Validation.isValidEmail("com.hiclark@vlad")
        
        XCTAssertTrue(test1)
        XCTAssertTrue(test2)
        XCTAssertTrue(test3)
        XCTAssertFalse(test4)
        XCTAssertFalse(test5)
    }
    
    /// Test phone validation
    func testPhoneValidation() {
        
        let test1 = Validation.isValidPhone("+16462754512", countryCode: "US")
        let test2 = Validation.isValidPhone("+380983280364", countryCode: "UA")
        let test3 = Validation.isValidPhone("+1666666666", countryCode: "US")
        
        XCTAssertTrue(test1)
        XCTAssertTrue(test2)
        XCTAssertFalse(test3)
    }
    
    /// Test postal code
    func testPostalCode() {
        
        let test1 = Validation.isValidPostalCode("11211")
        let test2 = Validation.isValidPostalCode("11214")
        let test3 = Validation.isValidPostalCode("e214")
        
        XCTAssertTrue(test1)
        XCTAssertTrue(test2)
        XCTAssertTrue(test3)
    }
    
    /// Test pass validation
    func testPasswordValidation() {
        
        let test1 = Validation.isValidPassword("11211")
        let test2 = Validation.isValidPassword("testtesttest")
        let test3 = Validation.isValidPassword("@#SADALSFIk")
        
        XCTAssertFalse(test1)
        XCTAssertTrue(test2)
        XCTAssertTrue(test3)
    }
    
    /// Test special chars
    func testSpecialChars() {
        
        let test1 = Validation.containsSpecialCharacters("@!@#11211")
        let test2 = Validation.containsSpecialCharacters("testtesttest")
        let test3 = Validation.containsSpecialCharacters("@#SADALSFIk")
        
        XCTAssertTrue(test1)
        XCTAssertFalse(test2)
        XCTAssertTrue(test3)
    }
    
    /// Test name validation
    func testnameValidation() {
        
        let test1 = Validation.validateName(first: "test", last: "")
        let test2 = Validation.validateName(first: "", last: "test")
        let test3 = Validation.validateName(first: "", last: "")
        let test4 = Validation.validateName(first: "vlad", last: "vlad")
        
        XCTAssertEqual(test1!, .lastName)
        XCTAssertEqual(test2!, .firstName)
        XCTAssertEqual(test3!, .firstName)
        XCTAssertNil(test4)
    }
    
    /// Test learning plan rate validation
    func testLearningPlanRate() {
        
        let test1 = Validation.validateLearningPlanRate(nil, duration: "20", frequency: "20")
        let test2 = Validation.validateLearningPlanRate("100", duration: "", frequency: "100")
        let test3 = Validation.validateLearningPlanRate("22", duration: "22", frequency: nil)
        let test4 = Validation.validateLearningPlanRate("22", duration: "22", frequency: "22")
        
        XCTAssertEqual(test1!, .rate)
        XCTAssertEqual(test2!, .duration)
        XCTAssertEqual(test3!, .frequency)
        XCTAssertNil(test4)
    }
    
    /// Session rate
    func testSessionRate() {
     
        let test1 = Validation.validateSessionRate(nil, duration: "22", day: Date(), time: Date())
        let test2 = Validation.validateSessionRate("22", duration: "", day: Date(), time: Date())
        let test3 = Validation.validateSessionRate("22", duration: "33", day: nil, time: Date())
        let test4 = Validation.validateSessionRate("22", duration: "33", day: Date(), time: nil)
        let test5 = Validation.validateSessionRate("22", duration: "33", day: Date(), time: Date())
        
        XCTAssertEqual(test1!, .rate)
        XCTAssertEqual(test2!, .duration)
        XCTAssertEqual(test3!, .date)
        XCTAssertEqual(test4!, .time)
        XCTAssertNil(test5)
    }
    
    /// Validate contact type
    func testContactType() {
        
        let test1 = Validation.validateContactType(type: .email, entry: "vlad@hiclark.com", country: nil)
        let test2 = Validation.validateContactType(type: .email, entry: "@@@..,,..", country: nil)
        let test3 = Validation.validateContactType(type: .mobile, entry: "+16462754512", country: "US")
        let test4 = Validation.validateContactType(type: .mobile, entry: "+164627ss54512", country: nil)
        
        XCTAssertNil(test1)
        XCTAssertEqual(test2!, .email)
        XCTAssertNil(test3)
        XCTAssertEqual(test4!, .phone)
    }
    
    /// Validate contact subject
    func testContactSubject() {
        
        let _ = createSubjectInDatabase().then { response-> Void in
         
            let test1 = Validation.validateContactSubject(nil)
            let test2 = Validation.validateContactSubject(response!)
            
            XCTAssertEqual(test1!, .subject)
            XCTAssertNil(test2)
        }
    }
    
    // MARK: - Utilities
    func createSubjectInDatabase()-> Promise<Subject?> {
        
        /// Test data
        let dictionary: [String: Any] = [
            "links": [
                "self": "https://manager-qa.hiclark.com/api/mobile/v1/subjects/a0d5c42a-52b0-4f12-a9c0-bfa47969c11c"
            ],
            "type": "subjects",
            "id": "a0d5c42a-52b0-4f12-a9c0-bfa47969c11c",
            ModelJSON.attributes: [
                SubjectJSON.category: "Achievement",
                SubjectJSON.name: "Academically Gifted"
            ]
        ]
        
        /// JSON
        let json: JSON = JSON(dictionary)
        return DatabaseManager.insertSync(Into<Subject>(), source: json).then { response-> Promise<Subject?> in
            /// Fetch db object
            return DatabaseManager.fetchExisting(response)
        }
    }
}
