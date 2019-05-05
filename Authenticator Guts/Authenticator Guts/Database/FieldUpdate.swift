//
//  FieldUpdate.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



/// Describes how to update a field in a database
public enum FieldUpdate<Value> {
    
    /// The field should not be updated
    case doNotUpdate
    
    /// The field should be updated
    /// - Parameter newValue: The new value for the field
    case performUpdate(newValue: Value)
}
