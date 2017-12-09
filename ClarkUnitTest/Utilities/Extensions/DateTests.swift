//
//  DateTests.swift
//  ClarkUnitTest
//
//  Created by Vladislav Zagorodnyuk on 10/26/17.
//  Copyright © 2017 Clark. All rights reserved.
//

import XCTest

class DateTests: XCTestCase {

    /// Years from date
    func testYears() {
        
        let date1 = generateTestDate1()
        let date2 = generateTestDate2()
        let date3 = generateTestDate3()
        
        XCTAssertEqual(2, date1.yearsFrom(date2))
        XCTAssertEqual(0, date2.yearsFrom(date3))
    }
    
    /// Months from date
    func testMonths() {
    
        let date1 = generateTestDate1()
        let date2 = generateTestDate2()
        let date3 = generateTestDate3()
        
        XCTAssertEqual(24, date1.monthsFrom(date2))
        XCTAssertEqual(0, date2.monthsFrom(date3))
    }
    
    /// Test weeks from date
    func testWeeks() {
        
        let date1 = generateTestDate1()
        let date2 = generateTestDate2()
        let date3 = generateTestDate4()
        
        XCTAssertEqual(104, date1.weeksFrom(date2))
        XCTAssertEqual(4, date3.weeksFrom(date2))
    }
    
    /// Test days from date
    func testDays() {
        
        let date1 = generateTestDate1()
        let date2 = generateTestDate2()
        let date3 = generateTestDate4()
        
        XCTAssertEqual(731, date1.daysFrom(date2))
        XCTAssertEqual(29, date3.daysFrom(date2))
    }
    
    /// Test hours from date
    func testHours() {
        
        let date1 = generateTestDate1()
        let date2 = generateTestDate2()
        let date3 = generateTestDate4()
        
        XCTAssertEqual(17544, date1.hoursFrom(date2))
        XCTAssertEqual(696, date3.hoursFrom(date2))
    }
    
    /// Test minutes from date
    func testMinutes() {
        
        let date1 = generateTestDate1()
        let date2 = generateTestDate2()
        let date3 = generateTestDate4()
        
        XCTAssertEqual(1052640, date1.minutesFrom(date2))
        XCTAssertEqual(41760, date3.minutesFrom(date2))
    }

    // MARK: - Utilities
    func generateTestDate1()-> Date {
        return Date(fromString: "2017-06-16T17:18:59.082083Z", format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ")!
    }
    
    func generateTestDate2()-> Date {
        return Date(fromString: "2015-06-16T17:18:59.082083Z", format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ")!
    }
    
    func generateTestDate3()-> Date {
        return Date(fromString: "2015-06-15T17:18:59.082083Z", format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ")!
    }
    
    func generateTestDate4()-> Date {
        return Date(fromString: "2015-07-15T17:18:59.082083Z", format: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ")!
    }
}
