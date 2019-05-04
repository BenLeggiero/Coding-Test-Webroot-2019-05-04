//
//  SignInViewController.swift
//  Authenticator UI
//
//  Created by Ben Leggiero on 5/4/19.
//  Copyright © 2019 Ben Leggiero. All rights reserved.
//

import Cocoa
import Authenticator_Guts



class SignInViewController: NSViewController {
    
    @IBOutlet private weak var usernameField: NSTextField!
    @IBOutlet private weak var passwordField: NSSecureTextField!
    @IBOutlet private weak var repeatPasswordLabel: NSTextField!
    @IBOutlet private weak var repeatPasswordField: NSSecureTextField!
    
    @IBOutlet private weak var passwordStrengthLabel: NSTextField!
    @IBOutlet private weak var passwordStrengthMeter: NSProgressIndicator!
    @IBOutlet private weak var passwordStrengthIndicatorLabel: NSTextField!
    
    @IBOutlet private weak var newUserCheckBox: NSButton!
    @IBOutlet private weak var signInButton: NSButton!
    
    
    public var onUserDidSignInSuccessfully: OnUserDidSignInSuccessfully? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        repeatPasswordField.delegate = self
        
        updatePurpose(isNewUser: isNewUser)
    }
    
    
    
    public typealias OnUserDidSignInSuccessfully = (_ user: AuthenticatedUser) -> Void
}



// MARK: - User action responders

private extension SignInViewController {
    
    @IBAction func didPressNewUserCheckbox(_ sender: NSButton) {
        let isChecked = sender.state == .on
        updatePurpose(isNewUser: isChecked)
    }
    
    
    @IBAction func didPressSignInButton(_ sender: NSButton) {
        if isNewUser {
            let passwordAcceptability = performBasicPasswordChecks()
            switch passwordAcceptability {
            case .badPassword:
                shakeWindow()
                
            case .passwordsDoNotMatch:
                shakeWindow()
                
            case .acceptable:
                Authenticator.registerNewUser(name: username, password: password)
            }
        }
        else {
            Authenticator.authenticate(username: username, password: password) {
                
            }
        }
    }
}



// MARK: - Convenience accessors

private extension SignInViewController {
    
    var username: String {
        return usernameField.stringValue
    }
    
    
    var password: String {
        return passwordField.stringValue
    }
    
    
    var repeatedPassword: String {
        return repeatPasswordField.stringValue
    }
    
    
    var isNewUser: Bool {
        return newUserCheckBox.state == .on
    }
    
    
    var passwordsMatch: Bool {
        return password == repeatedPassword
    }
}



// MARK: - Functionality

private extension SignInViewController {
    
    
    func updatePurpose(isNewUser: Bool) {
        let shouldHideNewUserSection = !isNewUser
        
        repeatPasswordField.isHidden = shouldHideNewUserSection
        repeatPasswordLabel.isHidden = shouldHideNewUserSection
        
        passwordStrengthMeter.isHidden = shouldHideNewUserSection
        passwordStrengthLabel.isHidden = shouldHideNewUserSection
        passwordStrengthIndicatorLabel.isHidden = shouldHideNewUserSection
        
        signInButton.stringValue = isNewUser
            ? "button.authentication.signIn".localized(comment: "Sign In")
            : "button.authentication.register".localized(comment: "Register")
    }
    
    
    func performBasicPasswordChecks() -> BasicPasswordCheckResult {
        guard passwordsMatch else {
            return .passwordsDoNotMatch
        }
        
        return BasicPasswordCheckResult(passwordStrength())
    }
    
    
    func passwordStrength() -> PasswordStrength {
        return PasswordStrengthChecker.determineStrength(of: passwordField.stringValue)
    }
    
    
    func checkPasswordLocally() {
        let strength = passwordStrength()
        let strengthVagueValue: VagueValue = {
            switch strength {
            case .bad(reason: .tooShort):
                return .low
                
            case .bad(reason: .alreadyUsedElsewhere):
                return .minimum
                
            case .acceptable:
                return .medium
                
            case .veryGood:
                return .high
                
            case .exceptional:
                return .maximum
            }
        }()
        
        passwordStrengthMeter.vagueValue = strengthVagueValue
        passwordStrengthIndicatorLabel.stringValue = strength.localizedDescription
    }
    
    
    func shakeWindow() {
        if let window = self.view.window {
            window.shake()
        }
        else {
            self.view.shake()
        }
    }
    
    
    
    /// The result of basic password validation
    enum BasicPasswordCheckResult {
        
        /// The user's password was unacceptably bad
        case badPassword
        
        /// The user's proposed new password and repeated new password do not match
        case passwordsDoNotMatch
        
        /// The user's password is acceptable
        case acceptable
        
        
        init(_ strength: PasswordStrength) {
            switch strength {
            case .bad(reason: _):
                self = .badPassword
                
            case .acceptable,
                 .veryGood,
                 .exceptional:
                self = .acceptable
            }
        }
    }
}



// MARK: - NSTextFieldDelegate

extension SignInViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ notification: Notification) {
        guard let sender = notification.object as? NSTextField else {
            assertionFailure("Wrong object")
            return
        }
        
        switch FieldTag(rawValue: sender.tag) {
        case .usernameField?:
            return
            
        case .passwordField?,
             .repeatPasswordField?:
            checkPasswordLocally()
            
        case .none:
            assertionFailure("Unknown text field tag: \(sender.tag)")
        }
    }
    
    
    
    fileprivate enum FieldTag: Int {
        case usernameField = 1
        case passwordField = 2
        case repeatPasswordField = 3
    }
}



// MARK: - Conformance

extension NSProgressIndicator: DescribableByVagueValue {
    
    public var vagueValue: VagueValue {
        get {
            return VagueValue(minValue: minValue, actualValue: doubleValue, maxValue: maxValue)
        }
        set {
            doubleValue = newValue.realize(minValue: minValue, maxValue: maxValue)
        }
    }
}
