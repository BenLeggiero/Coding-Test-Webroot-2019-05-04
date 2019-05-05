//
//  SHA512 Tests.swift
//  Authenticator GutsTests
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import XCTest
@testable import Authenticator_Guts



class SHA512_Tests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSha512() {
        let testString = "8yOrBmkd"
        let precomutedHash_byteArray: [UInt8] = [0xae, 0x59, 0x6d, 0x2d, 0x67, 0x96, 0x69, 0x00, 0xab, 0x7c, 0xd4, 0xd8, 0x31, 0xad, 0x02, 0x70, 0x8b, 0x34, 0x99, 0xf2, 0xe8, 0x1c, 0x60, 0x32, 0x9e, 0xb7, 0x7e, 0x77, 0xc1, 0xfa, 0xe7, 0xea, 0xc6, 0x03, 0x31, 0xd2, 0xfc, 0x14, 0x96, 0xb2, 0xe9, 0xb0, 0x4a, 0x67, 0x31, 0x17, 0xd6, 0x80, 0x1b, 0xd4, 0xc8, 0xcd, 0x7c, 0x7e, 0x1c, 0xe8, 0xc0, 0xac, 0xfc, 0x8b, 0x2f, 0x78, 0x5e, 0xae]
        let precomputedHash_hexString = "ae596d2d67966900ab7cd4d831ad02708b3499f2e81c60329eb77e77c1fae7eac60331d2fc1496b2e9b04a673117d6801bd4c8cd7c7e1ce8c0acfc8b2f785eae"
        let precomputedHash_base64String = "rlltLWeWaQCrfNTYMa0CcIs0mfLoHGAynrd+d8H65+rGAzHS/BSWsumwSmcxF9aAG9TIzXx+HOjArPyLL3herg=="
        
        XCTAssertEqual(testString.sha512Hex(), precomputedHash_hexString)
        
        XCTAssertEqual(testString.sha512(), Data(precomutedHash_byteArray))
        
        XCTAssertEqual(testString.sha512ByteArray(), precomutedHash_byteArray)
        
        XCTAssertEqual(testString.sha512Base64(), precomputedHash_base64String)
    }
}
