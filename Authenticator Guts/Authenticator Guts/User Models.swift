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
    public let password: Password
}



/// A user who has been registered in a user registry database
public struct RegisteredUserWithinDatabase {
    
    /// The universally-unique identifier of the user
    public let id: UUID
    
    /// The user's username
    public let username: String
    
    /// The secure form of the user's password
    public let password: Password
    
    /// The salt which we applied to the user's password at registration time
    public let passwordSalt: Data
    
    /// The name the user wants to display
    public let displayName: String?
    
    /// Indicates whether this user requires multi-factor authentication
    public let requiresMultiFactorAuthentication: Bool
    
    /// The MFA mechanism which the user most prefers and which has most recently worked.
    /// If this fails, then you should update the database and perform a new fetch to set this to another MFA mechanism
    public let latestWorkingPreferredMultiFactorAuthenticationMechanism: MultiFactorAuthenticationMechanism?
    
    
    public init(id: UUID,
                username: String,
                password: Password,
                passwordSalt: Data,
                displayName: String?,
                requiresMultiFactorAuthentication: Bool,
                latestWorkingPreferredMultiFactorAuthenticationMechanism: MultiFactorAuthenticationMechanism?
        ) {
        self.id = id
        self.username = username
        self.password = password
        self.passwordSalt = passwordSalt
        self.displayName = displayName
        self.requiresMultiFactorAuthentication = requiresMultiFactorAuthentication
        self.latestWorkingPreferredMultiFactorAuthenticationMechanism = latestWorkingPreferredMultiFactorAuthenticationMechanism
    }
    
    
    public init(id: UUID = UUID(),
                username: String,
                actualUserPassword: String,
                displayName: String?,
                requiresMultiFactorAuthentication: Bool,
                latestWorkingPreferredMultiFactorAuthenticationMechanism: MultiFactorAuthenticationMechanism?
        ) {
        let salt = Password.generateSalt()
        self.init(
            id: id,
            username: username,
            password: Password(actualUserPassword: actualUserPassword, salt: salt),
            passwordSalt: salt,
            displayName: displayName,
            requiresMultiFactorAuthentication: requiresMultiFactorAuthentication,
            latestWorkingPreferredMultiFactorAuthenticationMechanism: latestWorkingPreferredMultiFactorAuthenticationMechanism
        )
    }
    
    
    
    public func update(
        username: FieldUpdate<String> = .doNotUpdate,
        password: FieldUpdate<Update.WrappedPassword> = .doNotUpdate,
        displayName: FieldUpdate<String?> = .doNotUpdate,
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
    /// For documentation on the members, see `RegisteredUserWithinDatabase`
    public struct Update {
        
        /// The ID of the user to be updated
        public let existingUserId: UUID
        
        public let username: FieldUpdate<String>
        
        public let password: FieldUpdate<WrappedPassword>
        
        public let displayName: FieldUpdate<String?>
        
        public let requiresMultiFactorAuthentication: FieldUpdate<Bool>
        
        public let latestWorkingPreferredMultiFactorAuthenticationMechanism: FieldUpdate<MultiFactorAuthenticationMechanism?>
        
        
        public init(existingUserId: UUID,
            username: FieldUpdate<String> = .doNotUpdate,
            password: FieldUpdate<WrappedPassword> = .doNotUpdate,
            displayName: FieldUpdate<String?> = .doNotUpdate,
            requiresMultiFactorAuthentication: FieldUpdate<Bool> = .doNotUpdate,
            latestWorkingPreferredMultiFactorAuthenticationMechanism: FieldUpdate<MultiFactorAuthenticationMechanism?> = .doNotUpdate
        ) {
            self.existingUserId = existingUserId
            self.username = username
            self.password = password
            self.displayName = displayName
            self.requiresMultiFactorAuthentication = requiresMultiFactorAuthentication
            self.latestWorkingPreferredMultiFactorAuthenticationMechanism = latestWorkingPreferredMultiFactorAuthenticationMechanism
        }
        
        
        public func applied(to registeredUser: RegisteredUserWithinDatabase) -> RegisteredUserWithinDatabase {
            return RegisteredUserWithinDatabase(
                id: registeredUser.id,
                username: self.username ?? registeredUser.username,
                password: self.password.ifUpdating(use: { $0.password }, elseUse: { registeredUser.password }),
                passwordSalt: self.password.ifUpdating(use: { $0.salt }, elseUse: { registeredUser.passwordSalt }),
                displayName: self.displayName ?? registeredUser.displayName,
                requiresMultiFactorAuthentication: self.requiresMultiFactorAuthentication ?? registeredUser.requiresMultiFactorAuthentication,
                latestWorkingPreferredMultiFactorAuthenticationMechanism: self.latestWorkingPreferredMultiFactorAuthenticationMechanism ?? registeredUser.latestWorkingPreferredMultiFactorAuthenticationMechanism
            )
        }
        
        
        
        public typealias WrappedPassword = (password: Password, salt: Data)
    }
}



extension RegisteredUserWithinDatabase: Hashable {
    
    public static func == (lhs: RegisteredUserWithinDatabase, rhs: RegisteredUserWithinDatabase) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



// MARK: - Cross-Conversion

public extension AuthenticatedUser {
    
    /// Converts the model for a registered user into that of an authenticated user
    ///
    /// - Parameter registeredUser: The user who has been registered
    init(_ registeredUser: RegisteredUserWithinDatabase) {
        self.init(
            username: registeredUser.username,
            displayName: registeredUser.displayName
        )
    }
}
