//
//  PasswordStrengthChecker.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public enum PasswordStrengthChecker {
    // Empty on-purpose; all members are static
}



public extension PasswordStrengthChecker {
    
    static func determineStrength(of password: String) -> PasswordStrength {
        
        if isAlreadyUsedElsewhere(password) {
            return .bad(reason: .alreadyUsedElsewhere)
        }
        
        // TODO: Take more into account than length
        
        switch password.count {
        case ..<10:
            return .bad(reason: .tooShort)
            
        case 10..<20:
            return .acceptable
            
        case 20..<40:
            return .veryGood
            
        case 40...:
            return .exceptional
            
        default:
            assertionFailure("This branch should be impossible")
            return .bad(reason: .tooShort)
        }
    }
    
    
    
    private static func isAlreadyUsedElsewhere(_ password: String) -> Bool {
        // TODO: Use the API for https://haveibeenpwned.com to check the password again leaks
        return false
    }
}



/// Indicates how strong a password is
public enum PasswordStrength {
    
    /// The password is bad and must be imporved before it can be accepted
    /// - Parameter reason: The reason why the password is bad
    case bad(reason: BadReason)
    
    /// The password meets the bare minimum standards and may be accepted
    case acceptable
    
    /// The password meets/exceeds reccomendations
    case veryGood
    
    /// The password is exceptionally good and should always be accepted
    case exceptional
    
    
    
    /// Describes why a password was rejected
    public enum BadReason {
        
        /// The password was already used somewhere else
        case alreadyUsedElsewhere
        
        /// The password was too short
        case tooShort
    }
}



extension PasswordStrength: CustomStringConvertible {
    
    public var description: String {
        return localizedDescription
    }
    
    
    public var localizedDescription: String {
        switch self {
        case .bad(reason: .alreadyUsedElsewhere):
            return "passwordStrength.bad.alreadyUsedElsewhere".localized(comment: "Already used somewhere else")
            
        case .bad(reason: .tooShort):
            return "passwordStrength.bad.tooShort".localized(comment: "Too short")
            
        case .acceptable:
            return "passwordStrength.acceptable".localized(comment: "Acceptable")
            
        case .veryGood:
            return "passwordStrength.veryGood".localized(comment: "Very good")
            
        case .exceptional:
            return "passwordStrength.exceptional".localized(comment: "Exceptional")
        }
    }
}
