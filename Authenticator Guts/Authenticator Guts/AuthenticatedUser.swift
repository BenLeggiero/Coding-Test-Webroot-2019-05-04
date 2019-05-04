//
//  AuthenticatedUser.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// A user who has been authenticated
public struct AuthenticatedUser {
    
    /// The user's username
    let username: String
    
    /// The name the user wants to display
    let displayName: String
}
