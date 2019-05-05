//
//  UserRegistryDatabase.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// A database which can operate as a registry in which there are many users registered
public protocol UserRegistryDatabase {
    
    /// Attempts to insert a new user into the database
    ///
    /// - Parameters:
    ///   - username: The new user's username
    ///   - password: The new user's password
    ///   - callback: Called after the attempt has completed
    func insertNewUser(username: String, actualUserPassword: String, callback: @escaping InsertNewUserCallback)
    
    
    /// Attempts to find an existing user in the database
    ///
    /// - Parameters:
    ///   - username: The username to search for
    ///   - callback: Called after the search has completed
    func isUserRegistered(username: String, callback: @escaping IsUserRegisteredCallback)
    
    
    /// Attempts to update the given user in this database
    ///
    /// - Parameters:
    ///   - userUpdate: The model for the update to be perfomed
    ///   - callback:   Called when the update attempt is complete
    func updateExistingUser(_ userUpdate: RegisteredUserWithinDatabase.Update, callback: @escaping UserUpdateCallback)
}



// MARK: - Insert new user

public extension UserRegistryDatabase {
    
    /// Called after the attempt to insert a new user has completed
    typealias InsertNewUserCallback = (_ result: InsertNewUserResult) -> Void
    
    /// Describes the result of attempting to insert a new user into an authentication database
    typealias InsertNewUserResult = UserRegistryDatabaseInsertNewUserResult
}



/// Describes the result of attempting to insert a new user into an authentication database
public enum UserRegistryDatabaseInsertNewUserResult {
    /// The user was successfully inserted
    /// - Parameter registeredUser: The model of the user who has newly been registered
    case userSuccessfullyInserted(registeredUser: RegisteredUserWithinDatabase)
    
    /// The user could not be inserted now because that user has already been inserted in the past. Perhaps you meant
    /// to update the user instead?
    case userAlreadyInserted
    
    /// The user could not be inserted due to some unknown failure
    case unknownFailure
}



// MARK: - Is user registered?

public extension UserRegistryDatabase {
    
    /// Called after requesting whether a user is registered
    typealias IsUserRegisteredCallback = (_ result: IsUserRegisteredResult) -> Void
    
    /// Describes the result of requesting whether a user is registered
    typealias IsUserRegisteredResult = UserRegistryDatabaseIsUserRegisteredResult
}



/// Describes the result of requesting whether a user is registered
public enum UserRegistryDatabaseIsUserRegisteredResult {
    /// The user has already been registered
    /// - Parameter registeredUser: The model of the user who has already been registered
    case userAlreadyRegistered(registeredUser: RegisteredUserWithinDatabase)
    
    /// The user was not found in the registry
    case userNotFound
}



// MARK: - Update existing user

public extension UserRegistryDatabase {
    
    /// Called after requesting that a user in the registry database be updated
    typealias UserUpdateCallback = (_ result: UpdateUserResult) -> Void
    
    /// Describes the result of attempting to update a user in the user registry database
    typealias UpdateUserResult = UserRegistryDatabaseUserUpdateResult
}



/// Describes the result of attempting to update a user in the user registry database
public enum UserRegistryDatabaseUserUpdateResult {
    
    /// The user was successfuly updated in the registry database
    case successfullyUpdatedUser
    
    /// Could not find any user to update
    case userNotFound
    
    /// For some unknown reason, the user could not be updated
    case unknownFailure
}
