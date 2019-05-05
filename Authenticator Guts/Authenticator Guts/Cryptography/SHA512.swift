//
//  SHA512.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//
//  Thanks to zaph and omi5489 from StackOverflow for pointing me in the right direction
//  https://stackoverflow.com/a/46066276/3939277
//

import Foundation
import CommonCrypto



public extension String {
    
    func sha512Hex() -> String {
        guard let data = self.data(using: .utf8 , allowLossyConversion: true) else {
            assertionFailure("Could not datify string")
            return ""
        }
        return data.sha512Hex()
    }
    
    
    func sha512() -> Data {
        guard let data = self.data(using: .utf8 , allowLossyConversion: true) else {
            assertionFailure("Could not datify string")
            return Data()
        }
        return data.sha512()
    }
    
    
    // from https://stackoverflow.com/a/46066276/3939277
    func sha512ByteArray() -> [UInt8] {
        guard let data = self.data(using: .utf8 , allowLossyConversion: true) else {
            assertionFailure("Could not datify string")
            return []
        }
        return data.sha512ByteArray()
    }
    
    
    // from https://stackoverflow.com/a/46066276/3939277
    func sha512Base64() -> String {
        guard let data = self.data(using: .utf8 , allowLossyConversion: true) else {
            assertionFailure("Could not datify string")
            return ""
        }
        return data.sha512Base64()
    }
}



public extension Data {
    
    func sha512Hex() -> String {
        return sha512ByteArray()
            .lazy
            .map { String($0, radix: 0x10) }
            .joined()
    }
    
    
    func sha512() -> Data {
        let digest = sha512ByteArray()
        return Data(digest)
    }
    
    
    func sha512ByteArray() -> [UInt8] {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        let value =  self as NSData
        CC_SHA512(value.bytes, CC_LONG(value.length), &digest)
        
        return digest
    }
    
    
    func sha512Base64() -> String {
        return sha512().base64EncodedString(options: [])
    }
}
