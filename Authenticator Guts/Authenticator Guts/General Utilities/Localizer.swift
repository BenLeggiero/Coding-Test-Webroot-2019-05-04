//
//  Localizer.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension String {
    
    func localized(comment: StringLiteralType,
                   backupValue: String? = nil,
                   arguments: [CVarArg] = []) -> String {
        
        class Anchor {}
        
        
        
        let localizedString = NSLocalizedString(self,
                                                tableName: "Localizable",
                                                bundle: Bundle(for: Anchor.self),
                                                value: backupValue ?? comment,
                                                comment: comment)
        
        if arguments.isEmpty {
            return localizedString
        }
        else {
            return String.init(format: localizedString, arguments: arguments)
        }
    }
}
