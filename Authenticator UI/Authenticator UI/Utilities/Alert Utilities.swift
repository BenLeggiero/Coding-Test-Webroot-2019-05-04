//
//  Alert Utilities.swift
//  Authenticator UI
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Cocoa



public extension NSAlert {
    
    /// Presents this alert in a user-friendly way
    ///
    /// - Parameters:
    ///   - window:            The window upon which we might present the alert
    ///   - completionHandler: [optional] Passed the result of the user's interaction with the alert. Defaults to `nil`
    func present(on window: NSWindow?, completionHandler: ((NSApplication.ModalResponse) -> Void)? = nil) {
        if let window = window {
            self.beginSheetModal(for: window, completionHandler: completionHandler)
        }
        else {
            let result = self.runModal()
            completionHandler?(result)
        }
    }
}
