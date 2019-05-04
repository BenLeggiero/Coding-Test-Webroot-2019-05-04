//
//  MultiFactorAuthenticatorModel.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// Represents an external authentication service, such as Google Authenticator
public struct MutliFactorAuthenticatorModel {
    
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



public extension MutliFactorAuthenticatorModel {
    
}
