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
        
        XCTAssertEqual(numbers.closest(to: -99), 1)
    }
}
