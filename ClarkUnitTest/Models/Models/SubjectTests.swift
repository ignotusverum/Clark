//
//  SubjectTests.swift
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

class SubjectTests: XCTestCase {

    // MARK: - Initialization tests
    func testInitFromJSON() {
        
        /// Test initialization
        let _ = createSubjectInDatabase().then { response-> Void in
            
            XCTAssertEqual(response!.category, "Achievement")
            XCTAssertEqual(response!.name, "Academically Gifted")
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
