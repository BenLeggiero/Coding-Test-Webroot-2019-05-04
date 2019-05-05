//
//  Password.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// A securely-stored user password
public struct Password {
    
    /// The digested form of the password
    public let digested: Data
    
    
    public init(actualUserPassword: String, salt: Data) {
        let naïvePasswordDigest = actualUserPassword.sha512()
        let saltedDigest = naïvePasswordDigest + salt
        self.digested = saltedDigest.sha512()
    }
}



public extension Password {
    
    /// Securely detemines if this password is the same as the given one
    ///
    /// - Parameters:
    ///   - actualUserPassword: The string that the user gave us as their password
    ///   - salt:               The salt that we mixed in with the password upon their registration
    /// - Returns: `true` iff the given password is the one the user gave us, assuming the given `salt` is correct
    func isEqual(toActualUserPassword actualUserPassword: String, salt: Data) -> Bool {
        return Password(actualUserPassword: actualUserPassword, salt: salt).digested == self.digested
    }
}



public extension Password {
    /// Generates a new, unique salt for hashing
    ///
    /// - Returns: A unique salt
    static func generateSalt() -> Data {
        guard let uuidData = UUID().uuidString.data(using: .utf8, allowLossyConversion: true) else {
            assertionFailure("Failed to turn UUID into data")
            return Data([0xba, 0xdc, 0xde])
        }
        
        return uuidData
    }
}
