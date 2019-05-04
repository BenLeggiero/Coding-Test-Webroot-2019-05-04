//
//  Localizer.swift
//  Authenticator Guts
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Foundation



public extension String {
    
    func localized(comment: StringLiteralType, backupValue: String? = nil) -> String {
        
        class Anchor {}
        
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: Bundle(for: Anchor.self),
                                 value: backupValue ?? comment,
                                 comment: comment)
    }
}
