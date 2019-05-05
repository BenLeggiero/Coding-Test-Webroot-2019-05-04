//
//  MockUserRegistryDatabase.swift
//  Authenticator UI
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation
import Authenticator_Guts



/// This is a mock of a user registry database, for testing purposes.
///
/// In production, this might simply be a wrapper around a network interface to a remote database
internal class MockUserRegistryDatabase: UserRegistryDatabase {
    
    /// Our pretend table of users
    private var users = [UUID : RegisteredUserWithinDatabase]()
    
    
    init() {
        let sampleUserA = RegisteredUserWithinDatabase(
            username: "JaneDoe",
            actualUserPassword: "A password which is seemingly very strong",
            displayName: "Jane Doe 🦌",
            requiresMultiFactorAuthentication: true,
            latestWorkingPreferredMultiFactorAuthenticationMechanism: .genericAuthenticatorWithCode
        )
        
        let sampleUserB = RegisteredUserWithinDatabase(
            username: "jimmy",
            actualUserPassword: "password1",
            displayName: "That Guy",
            requiresMultiFactorAuthentication: false,
            latestWorkingPreferredMultiFactorAuthenticationMechanism: nil
        )
        
        users[sampleUserA.id] = sampleUserA
        users[sampleUserB.id] = sampleUserB
    }
    
    
    func insertNewUser(username: String, actualUserPassword: String, callback: @escaping InsertNewUserCallback) {
        isUserRegistered(username: username) { result in
            switch result {
            case .userAlreadyRegistered(registeredUser: _):
                return callback(.userAlreadyInserted)
                
            case .userNotFound:
                let newUser = RegisteredUserWithinDatabase(
                    username: username,
                    actualUserPassword: actualUserPassword,
                    displayName: nil,
                    requiresMultiFactorAuthentication: false,
                    latestWorkingPreferredMultiFactorAuthenticationMechanism: nil
                )
                self.users[newUser.id] = newUser
                return callback(.userSuccessfullyInserted(registeredUser: newUser))
            }
        }
    }
    
    
    func isUserRegistered(username: String, callback: @escaping IsUserRegisteredCallback) {
        guard let registeredUser = users.first(where: { $0.value.username == username })?.value else {
            return callback(.userNotFound)
        }
        return callback(.userAlreadyRegistered(registeredUser: registeredUser))
    }
    
    
    private func isUserRegistered(id: UUID, callback: @escaping IsUserRegisteredCallback) {
        guard let registeredUser = users[id] else {
            return callback(.userNotFound)
        }
        return callback(.userAlreadyRegistered(registeredUser: registeredUser))
    }
    
    
    func updateExistingUser(_ userUpdate: RegisteredUserWithinDatabase.Update, callback: @escaping UserUpdateCallback) {
        isUserRegistered(id: userUpdate.existingUserId) { result in
            switch result {
            case .userNotFound:
                return callback(.userNotFound)
                
            case .userAlreadyRegistered(let registeredUser):
                let updatedUser = userUpdate.applied(to: registeredUser)
                self.users[registeredUser.id] = updatedUser
                return callback(.successfullyUpdatedUser)
            }
        }
    }
}
