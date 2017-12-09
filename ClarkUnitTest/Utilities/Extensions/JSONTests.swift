//
//  JSONTests.swift
//  ClarkUnitTest
//
//  Created by Vladislav Zagorodnyuk on 10/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import XCTest
import SwiftyJSON

class JSONTests: XCTestCase {
 
    /// Test nsstring
    func testNSString() {
        
        /// Generate dict
        let testDict = ["test": "test"]
        let testJSON = JSON(testDict)
        
        XCTAssertEqual(testJSON["test"].nsString!, "test")
    }
    
    /// Testing price
    func testingPrice() {
        
        /// Generate dict
        let testDict = ["test": 400]
        let testJSON = JSON(testDict)
        
        XCTAssertEqual(testJSON["test"].price, 4)
    }
    
    /// Testing JSON
    func testingPhone() {
        
        /// Generate dict
        let testDict = ["test": "+16462754512"]
        let testJSON = JSON(testDict)
        
        XCTAssertEqual(testJSON["test"].phone!, "(646) 275-4512")
    }
}
