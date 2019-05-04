//
//  AppDelegate.swift
//  Authenticator UI
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Cocoa
import Authenticator_Guts



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var authenticationSheet: NSWindow!
    
    private lazy var signInViewController: SignInViewController = {
        let signInViewController = SignInViewController()
        signInViewController.onUserDidSignInSuccessfully = userDidSignInSuccessfully
        return signInViewController
    }()
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        authenticationSheet.contentViewController = signInViewController
    }
    
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Nothing to do
    }
    
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}



private extension AppDelegate {
    
    func userDidSignInSuccessfully(user: AuthenticatedUser) {
        <#function body#>
    }
}
