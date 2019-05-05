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



public extension FieldUpdate {
    static func ??(lhs: FieldUpdate<Value>, rhs: Value) -> Value {
        return lhs.ifUpdating(use: { $0 }, elseUse: { rhs })
    }
    
    
    func ifUpdating<Transformed>(use transformer: (Value) -> Transformed,
                                 elseUse backup: () -> Transformed) -> Transformed
    {
        switch self {
        case .doNotUpdate:
            return backup()
            
        case .performUpdate(let newValue):
            return transformer(newValue)
        }
    }
}
