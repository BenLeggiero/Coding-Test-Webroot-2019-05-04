//
//  MultiFactorAuthenticationMechanism.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// Represents an external authentication mechanism, such as Google Authenticator
public struct MultiFactorAuthenticationMechanism {
    
    /// The universally-unique identifier of the servie, so an algorithm can tell services apart even if their brand
    /// name chagnes
    let serviceId: UUID
    
    /// The brand name of the service, to be presented to the user
    let localizedServiceName: String
    
    /// The call-to-action to be presented to the user in order, in order to tell them that they need to use the other
    /// service to finish authenticating.
    let localizedCallToAction: String
    
    
    public init(serviceId: UUID,
                localizedServiceName: String,
                localizedCallToAction: String) {
        self.serviceId = serviceId
        self.localizedServiceName = localizedServiceName
        self.localizedCallToAction = localizedCallToAction
    }
}



public extension MultiFactorAuthenticationMechanism {
    
    /// Models a generic authenticator app which has a rotating code which the user types in
    static let genericAuthenticatorWithCode = MultiFactorAuthenticationMechanism(
        serviceId: UUID(uuid: (0xD4, 0x78, 0x99, 0xB7, 0x1C, 0x06, 0x49, 0x63, 0xB0, 0xA5, 0xC1, 0xD2, 0xCC, 0x5F, 0x5F, 0x5B)), // D47899B7-1C06-4963-B0A5-C1D2CC5F5F5B
        localizedServiceName: "Authenticator App",
        localizedCallToAction: "Enter the code from your authenticator app")
    
    /// Models an email authentication scheme wherein the service sends a verification link to the user's email address
    static let emailAuthentication = MultiFactorAuthenticationMechanism(
        serviceId: UUID(uuid: (0x88, 0xBE, 0x4E, 0xF8, 0x7C, 0x3A, 0x47, 0x2C, 0x83, 0x1A, 0x7F, 0xBC, 0x5F, 0xEF, 0x97, 0x88)), // 88BE4EF8-7C3A-472C-831A-7FBC5FEF9788
        localizedServiceName: "Email Verification",
        localizedCallToAction: "Click the verification link we sent to your email address")
}



extension MultiFactorAuthenticationMechanism: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(serviceId)
    }
}



/// Models the result of the authentication request
public enum MultiFactorAuthenticationResult {
    
    /// The user has successfully authenticated theirself. Passing this back continues the authentication process and
    /// will re-call some callbacks.
    /// - Parameter token: The token which was the result of the user authenticating theirself
    case authenticated(token: String)
    
    /// The user explicitly rejected the MFA request
    case userRejectedRequest
    
    /// The user gave no response within the required time
    case noResponse
}



/// The type of function to be called when MFA has completed
/// - Parameter result: The result of the authentication request
public typealias MultiFactorAuthenticationCallback = (_ result: MultiFactorAuthenticationResult) -> Void
