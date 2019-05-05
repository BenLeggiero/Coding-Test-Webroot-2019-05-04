//
//  User Models.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// A user who has been authenticated
public struct AuthenticatedUser {
    
    /// The user's username
    public let username: String
    
    /// The name the user wants to display
    public let displayName: String?
}



/// A user who has yet to be authenticated
public struct UnauthenticatedUser {
    
    /// The user's username
    public let username: String
    
    /// The user's password's hash value
    public let passwordHash: Data
}



/// A user who has been registered in a user registry
public struct RegisteredUser {
    
    /// The universally-unique identifier of the user
    public let id: UUID
    
    /// The user's username
    public let username: String
    
    /// The name the user wants to display
    public let displayName: String?
    
    /// Indicates whether this user requires multi-factor authentication
    public let requiresMultiFactorAuthentication: Bool
    
    /// The MFA mechanism which the user most prefers and which has most recently worked.
    /// If this fails, then you should update the database and perform a new fetch to set this to another MFA mechanism
    public let latestWorkingPreferredMultiFactorAuthenticationMechanism: MultiFactorAuthenticationMechanism?
    
    
    
    public func update(
        username: FieldUpdate<String> = .doNotUpdate,
        displayName: FieldUpdate<String> = .doNotUpdate,
        requiresMultiFactorAuthentication: FieldUpdate<Bool> = .doNotUpdate,
        latestWorkingPreferredMultiFactorAuthenticationMechanism: FieldUpdate<MultiFactorAuthenticationMechanism?> = .doNotUpdate
        ) -> Update
    {
        return Update(
            existingUserId: id,
            username: username,
            displayName: displayName,
            requiresMultiFactorAuthentication: requiresMultiFactorAuthentication,
            latestWorkingPreferredMultiFactorAuthenticationMechanism: latestWorkingPreferredMultiFactorAuthenticationMechanism
        )
    }
    
    
    
    /// Describes how to update a user in a registry database.
    /// For documentation on the members, see `RegisteredUser`
    public struct Update {
        
        /// The ID of the user to be updated
        public let existingUserId: UUID
        
        public let username: FieldUpdate<String>
        
        public let displayName: FieldUpdate<String>
        
        public let requiresMultiFactorAuthentication: FieldUpdate<Bool>
        
        public let latestWorkingPreferredMultiFactorAuthenticationMechanism: FieldUpdate<MultiFactorAuthenticationMechanism?>
        
        
        public init(existingUserId: UUID,
            username: FieldUpdate<String> = .doNotUpdate,
            displayName: FieldUpdate<String> = .doNotUpdate,
            requiresMultiFactorAuthentication: FieldUpdate<Bool> = .doNotUpdate,
            latestWorkingPreferredMultiFactorAuthenticationMechanism: FieldUpdate<MultiFactorAuthenticationMechanism?> = .doNotUpdate
        ) {
            self.existingUserId = existingUserId
            self.username = username
            self.displayName = displayName
            self.requiresMultiFactorAuthentication = requiresMultiFactorAuthentication
            self.latestWorkingPreferredMultiFactorAuthenticationMechanism = latestWorkingPreferredMultiFactorAuthenticationMechanism
        }
    }
}



// MARK: - Cross-Conversion

public extension AuthenticatedUser {
    
    /// Converts the model for a registered user into that of an authenticated user
    ///
    /// - Parameter registeredUser: The user who has been registered
    init(_ registeredUser: RegisteredUser) {
        self.init(
            username: registeredUser.username,
            displayName: registeredUser.displayName
        )
    }
}
