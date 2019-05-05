//
//  Comparable Number Array Extensions Tests.swift
//  Authenticator UITests
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import XCTest
@testable import Authenticator_UI



class Comparable_Number_Array_Extensions_Tests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testClosest() {
        let numbers: [Double] = [1, 11, 3, 7]
        
        XCTAssertEqual(numbers.closest(to:  -99),  1)
        XCTAssertEqual(numbers.closest(to:    0),  1)
        XCTAssertEqual(numbers.closest(to:  0.5),  1)
        XCTAssertEqual(numbers.closest(to:  0.9),  1)
        XCTAssertEqual(numbers.closest(to:    1),  1)
        XCTAssertEqual(numbers.closest(to:  1.1),  1)
        XCTAssertEqual(numbers.closest(to:  1.9),  1)
        XCTAssertEqual(numbers.closest(to:    2),  1)
        XCTAssertEqual(numbers.closest(to:  2.5),  3)
        XCTAssertEqual(numbers.closest(to:    3),  3)
        XCTAssertEqual(numbers.closest(to:    4),  3)
        XCTAssertEqual(numbers.closest(to:    5),  3)
        XCTAssertEqual(numbers.closest(to:  5.1),  7)
        XCTAssertEqual(numbers.closest(to:  5.5),  7)
        XCTAssertEqual(numbers.closest(to:    6),  7)
        XCTAssertEqual(numbers.closest(to:  6.9),  7)
        XCTAssertEqual(numbers.closest(to:    7),  7)
        XCTAssertEqual(numbers.closest(to:  7.1),  7)
        XCTAssertEqual(numbers.closest(to:    9),  7)
        XCTAssertEqual(numbers.closest(to:  9.1), 11)
        XCTAssertEqual(numbers.closest(to:   10), 11)
        XCTAssertEqual(numbers.closest(to: 10.9), 11)
        XCTAssertEqual(numbers.closest(to:   11), 11)
        XCTAssertEqual(numbers.closest(to: 11.1), 11)
        XCTAssertEqual(numbers.closest(to:   99), 11)
    }
}
