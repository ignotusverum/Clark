//
//  File.swift
//  ClarkUnitTest
//
//  Created by Vladislav Zagorodnyuk on 10/23/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import XCTest
import CoreStore
import PromiseKit
import SwiftyJSON
import EZSwiftExtensions

class PermissionsTest: XCTestCase {
    
    // MARK: - Initialization tests
    func testInitFromJSON() {
        
        /// Create permissions
        let permissoins = createPermissions()
        
        /// Test permissions
        XCTAssertEqual(permissoins.ccInvoice!.isEnabled, true)
        XCTAssertEqual(permissoins.sessionAdd!.isEnabled, true)
        XCTAssertEqual(permissoins.ccPayments!.isEnabled, true)
        XCTAssertEqual(permissoins.studentAdd!.isEnabled, true)
        XCTAssertEqual(permissoins.ccReminders!.isEnabled, true)
        XCTAssertEqual(permissoins.learningPlans!.isEnabled, true)
        XCTAssertEqual(permissoins.sessionReport!.isEnabled, true)
        XCTAssertEqual(permissoins.tutoringProfile!.isEnabled, true)
        XCTAssertEqual(permissoins.clientContracts!.isEnabled, true)
        XCTAssertEqual(permissoins.sessionReminders!.isEnabled, true)
        XCTAssertEqual(permissoins.clarkerResponseTime!.isEnabled, true)
        XCTAssertEqual(permissoins.automatedSessionBooking!.isEnabled, true)
    }
    
    // MARK: - Utilities
    func createPermissions()-> Permissions {
        
        /// Test data
        let dictionary: [String: Any] = [
            PermissionsJSON.profile: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.sessions: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.students: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.ccInvoices: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.ccPayments: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.ccReminders: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.responseTime: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.learningPlans: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.sessionsReports: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.sessionsBooking: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.clientContracts: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.backgroundCheck: [PermissionsProtocolJSON.isEnabled: true],
            PermissionsJSON.sessionsReminders: [PermissionsProtocolJSON.isEnabled: true]
        ]
        
        /// JSON
        let json: JSON = JSON(dictionary)
        return Permissions(source: json)
    }
}
