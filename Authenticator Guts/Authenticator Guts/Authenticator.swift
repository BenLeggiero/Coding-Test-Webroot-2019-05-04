//
//  Authenticator.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public class Authenticator {
    
    let database: AuthenticationDatabase
    
    func registerNewUser(name: String, password: String) {
        // TODO
    }
    
    
    func authenticate(username: String, password: String, callback: AuthenticationCallback) {
        // TODO
    }
    
    
    
    /// Called when the sign-in process has completed. This is called whether or not the process was successful.
    typealias AuthenticationCallback = (_ result: AuthenticationResult) -> Void
    
    
    
    /// Describes the result of authentication
    enum AuthenticationResult {
        ///
        case noSuchUserFound
        case userWasRemoved
        case otherFactorRequired(otherFactor: MultiFactorAuthenticatorModel, onOtherFactorFetched: MultiFactorFetchCallback)
        case authenticatedSuccessfully
    }
}
