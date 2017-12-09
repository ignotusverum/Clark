//
//  VersionTests.swift
//  ClarkUnitTest
//
//  Created by Vladislav Zagorodnyuk on 10/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import XCTest

class VersionTests: XCTestCase {

    /// Test version check
    func testVersionCheck() {
        
        let versionTest1 = VersionManager.isVersion("3", greaterThan: "2")
        let versionTest2 = VersionManager.isVersion("0.1", greaterThan: "0")
        let versionTest3 = VersionManager.isVersion("1.1.9", greaterThan: "1.2.0")
        
        XCTAssert(versionTest1)
        XCTAssert(versionTest2)
        XCTAssert(versionTest3)
    }
}
