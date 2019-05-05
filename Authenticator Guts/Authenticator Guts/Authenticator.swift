//
//  Authenticator.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// Assumes the responsibility of authenticating users
public class Authenticator {
    
    /// The database wherein users are registered
    let registryDatabase: UserRegistryDatabase
    
    init(registryDatabase: UserRegistryDatabase) {
        self.registryDatabase = registryDatabase
    }
}



// MARK: - Registration

public extension Authenticator {
    
    /// Starts the process of registering a new user
    ///
    /// - Parameters:
    ///   - username: The new user's username
    ///   - password: The new user's password
    ///   - callback: Called once the registration process is complete, whether or not that was a success
    func registerNewUser(username: String, password: String, callback: @escaping RegistrationCallback) {
        registryDatabase.insertNewUser(username: username, password: password) { result in
            switch result {
            case .userSuccessfullyInserted(let registeredUser):
                return callback(.registeredSuccessfully(authenticatedUser: AuthenticatedUser(registeredUser)))
                
            case .userAlreadyInserted:
                return callback(.userAlreadyRegistered)
                
            case .unknownFailure:
                return callback(.otherFailure)
            }
        }
    }
    
    
    
    /// Called when the registration process has completed. This is called whether or not the process was successful.
    typealias RegistrationCallback = (_ result: RegistrationResult) -> Void
    
    
    
    /// Describes result of registration
    enum RegistrationResult {
        /// The user has been successfully registered
        /// - Parameter authenticatedUser: The user who was just successfully registered
        case registeredSuccessfully(authenticatedUser: AuthenticatedUser)
        
        /// The user has already performed registration in our system. You should then choose to `authenticate`
        case userAlreadyRegistered
        
        /// Somthing failed that we weren't expecting
        case otherFailure
    }
}



// MARK: - Authentication

public extension Authenticator {
    
    /// Begins the authentication process for the given user
    ///
    /// - Parameters:
    ///   - username: The username which the user has provided to us
    ///   - password: The password which the user has provided to us
    ///   - callback: Called once authentication is completed
    func authenticate(username: String, password: String, callback: @escaping AuthenticationCallback) {
        
        /// Encapsualtes the logic perfomed after the user was definitely found in the registry database
        ///
        /// - Parameter registeredUser: The user which we found was registered
        func userFound(_ registeredUser: RegisteredUser) {
            
            /// Encapsulates the logic for handling a broken MFA mechanism.
            ///
            /// This updates the registry database to remove the latest preferred MFA mechanism from the user, and then
            /// starts over assuming the database will give us the next-most appropriate one
            func mfaMechanismWasBroken() {
                registryDatabase.updateExistingUser(registeredUser.update(latestWorkingPreferredMultiFactorAuthenticationMechanism: .performUpdate(newValue: nil))) { updateResult in
                    switch updateResult {
                    case .successfullyUpdatedUser:
                        return startAuthentication()
                        
                    case .unknownFailure:
                        return callback(.unexpectedFailure)
                    }
                }
            }
            
            
            if registeredUser.requiresMultiFactorAuthentication {
                guard let mfaMechanism = registeredUser.latestWorkingPreferredMultiFactorAuthenticationMechanism else {
                    NSLog("No MFA mechanism, but user requires it: \(registeredUser.id)")
                    return callback(.unexpectedFailure)
                }
                
                return callback(.otherFactorRequired(otherFactor: mfaMechanism, onAuthenticationComplete: { authResult in
                    switch authResult {
                    case .authenticated:
                        return callback(.authenticatedSuccessfully(authenticatedUser: AuthenticatedUser(registeredUser)))
                        
                    case .userRejectedRequest:
                        return callback(.userCancelledAuthentication)
                        
                    case .noResponse:
                        return mfaMechanismWasBroken()
                    }
                }))
            }
            else {
                return callback(.authenticatedSuccessfully(authenticatedUser: AuthenticatedUser(registeredUser)))
            }
        }
        
        
        /// Begins the authentication process, perhaps not for the first time in this session
        func startAuthentication() {
            registryDatabase.isUserRegistered(username: username) { isRegisteredResult in
                switch isRegisteredResult {
                case .userAlreadyRegistered(let registeredUser):
                    userFound(registeredUser)
                    
                case .userNotFound:
                    return callback(.noSuchUserFound)
                }
            }
        }
        
        
        startAuthentication()
    }
    
    
    
    /// Called when the sign-in process has completed. This is called whether or not the process was successful.
    typealias AuthenticationCallback = (_ result: AuthenticationResult) -> Void
    
    
    
    /// Describes the result of authentication
    enum AuthenticationResult {
        /// The user has been successfully authenticated
        /// - Parameter authenticatedUser: The user who was just successfully authenticated
        case authenticatedSuccessfully(authenticatedUser: AuthenticatedUser)
        
        /// The user was not found in the system
        case noSuchUserFound
        
        /// The user has been removed from the system and thus cannot log in
        case userWasRemoved
        
        /// The user needs to also authenticate theirself via some MFA
        /// - Parameters:
        ///   - otherFactor:              The model for the other authentication system which we must call upon
        ///   - onAuthenticationComplete: The function which you should call once the authentication has completed
        case otherFactorRequired(otherFactor: MultiFactorAuthenticationMechanism, onAuthenticationComplete: MultiFactorAuthenticationCallback)
        
        /// The user interrupted the process by choosing to not authenticate at all
        case userCancelledAuthentication
        
        /// The user could not be authenticated due to some unexpected failure
        case unexpectedFailure
    }
}
