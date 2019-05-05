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
    
    @IBOutlet private weak var inlineAlertIcon: NSImageView!
    @IBOutlet private weak var inlineAlertLabel: NSTextField!
    
    @IBOutlet private weak var newUserCheckBox: NSButton!
    @IBOutlet private weak var signInButton: NSButton!
    
    fileprivate lazy var allUserInputControls: [NSControl] = [
        usernameField,
        passwordField,
        repeatPasswordField,
        newUserCheckBox,
        signInButton
    ]
    
    
    public var authenticator: Authenticator? = nil
    public var onUserDidSignInSuccessfully: OnUserDidSignInSuccessfully? = nil
    
    fileprivate var broadState: BroadState = .userIsEnteringInformation {
        didSet {
            updateBroadState()
        }
    }
    
    fileprivate var inlineTextAlertText: String? = nil {
        didSet {
            updateInlineTextAlert()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameField.delegate = self
        passwordField.delegate = self
        repeatPasswordField.delegate = self
        
        updateUiApproach(isNewUser: isNewUser)
    }
    
    
    
    public typealias OnUserDidSignInSuccessfully = (_ user: AuthenticatedUser) -> Void
}



// MARK: - User action responders

private extension SignInViewController {
    
    @IBAction func didPressNewUserCheckbox(_ sender: NSButton) {
        let isChecked = sender.state == .on
        updateUiApproach(isNewUser: isChecked)
    }
    
    
    @IBAction func didPressSignInButton(_ sender: NSButton) {
        if isNewUser {
            let passwordAcceptability = performBasicPasswordChecks()
            switch passwordAcceptability {
            case .badPassword:
                alertUser(of: .badPassword)
                shakeWindow()
                
            case .passwordsDoNotMatch:
                alertUser(of: .passwordMismatch)
                shakeWindow()
                
            case .acceptable:
                performRegistration()
            }
        }
        else {
            performSignIn()
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



// MARK: - UI behavior & introspection

private extension SignInViewController {
    
    
    func updateUiApproach(isNewUser: Bool) {
        let shouldHideNewUserSection = !isNewUser
        
        repeatPasswordField.isHidden = shouldHideNewUserSection
        repeatPasswordLabel.isHidden = shouldHideNewUserSection
        
        passwordStrengthMeter.isHidden = shouldHideNewUserSection
        passwordStrengthLabel.isHidden = shouldHideNewUserSection
        passwordStrengthIndicatorLabel.isHidden = shouldHideNewUserSection
        
        signInButton.title = isNewUser
            ? "button.authentication.register".localized(comment: "Register")
            : "button.authentication.signIn".localized(comment: "Sign In")
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
        
        inlineTextAlertText = nil
        
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
    
    
    func updateBroadState() {
        
        let shouldAllowBroadUserInput: Bool
        
        switch broadState {
        case .userIsEnteringInformation:
            shouldAllowBroadUserInput = true
            
        case .authenticatingInBackground:
            shouldAllowBroadUserInput = false
        }
        
        allUserInputControls.forEach { control in
            control.isEnabled = shouldAllowBroadUserInput
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
    
    
    
    /// Describes the broad state of the UI
    enum BroadState {
        /// The user is currently entering information; all entering-information fields should be enabled appropriately
        case userIsEnteringInformation
        
        /// The app is currently working in the background to authenticate the user; the user should not be allowed to
        /// change information or double-start the process
        case authenticatingInBackground
    }
}



// MARK: - Alerting

private extension SignInViewController {
    
    func alertUser(of userAlert: UserAlert) {
        
        inlineTextAlertText = nil
        
        switch userAlert {
        case .badAuthenticator:
            alertUserUsingNsAlert(title: "dialog.badAuthenticator.title".localized(comment: "Something went wrong"),
                                  bodyText: "dialog.badAuthenticator.body".localized(comment: "Could not communicate with server"),
                                  style: .critical)
            
        case .noSuchUserFound:
            alertUserUsingInlineText("message.inlineAlert.notYetRegistered".localized(comment: "You have not registered yet"))
            
        case .accountDeleted:
            alertUserUsingInlineText("message.inlineAlert.accountDeleted".localized(comment: "Your account was deleted"))
            
        case .badPassword:
            alertUserUsingInlineText("message.inlineAlert.badPassword".localized(comment: "That password is incorrect"))
            
        case .passwordMismatch:
            alertUserUsingInlineText("message.inlineAlert.passwordMismatch".localized(comment: "Those passwords must be the same"))
            
        case .todo(component: .mfa):
            alertUserUsingNsAlert(title: "dialog.unimplementedMfa.title".localized(comment: "Sorry, MFA is not yet supported"),
                                  bodyText: "dialog.unimplementedMfa.body".localized(comment: "We couldn't sign you in because we don't yet support MFA"),
                                  style: .critical)
        }
    }
    
    
    private func alertUserUsingNsAlert(title: String,
                                       bodyText: String,
                                       style: NSAlert.Style) {
        let alert = NSAlert()
        alert.informativeText = title
        alert.messageText = bodyText
        alert.alertStyle = style
        alert.present(on: self.view.window)
    }
    
    
    private func alertUserUsingInlineText(_ newAlertText: String) {
        inlineTextAlertText = newAlertText
    }
    
    
    func updateInlineTextAlert() {
        if let inlineTextAlertText = inlineTextAlertText {
            inlineAlertLabel.stringValue = inlineTextAlertText
            inlineAlertIcon.isHidden = false
            inlineAlertLabel.isHidden = false
            
            inlineAlertLabel.shake()
            inlineAlertIcon.shake()
        }
        else {
            inlineAlertIcon.isHidden = true
            inlineAlertLabel.isHidden = true
        }
    }
    
    
    
    /// Generally describes of what we want to alert the user
    enum UserAlert {
        /// Tell the user that they couldn't be authenticated due to some system problem
        case badAuthenticator
        
        /// Tell the user that they gave us the wrong password
        case badPassword
        
        /// Tell the user that their repeated passwords aren't the same
        case passwordMismatch
        
        /// Tell the user that, though we tried to sign them in, it seems they're not in the system
        case noSuchUserFound
        
        /// Tell the user that, though they were found in the system, their account was already deleted
        case accountDeleted
        
        /// Tell the user that we have not implemented some required functionality
        /// - Parameter component: The part of the app which we have not yet implemented
        case todo(component: UnfinishedComponent)
    }
    
    
    
    /// Some part of the app which we have not yet implemented
    enum UnfinishedComponent {
        /// Multi-Factor Authentication
        case mfa
    }
}



// MARK: - Functionality

private extension SignInViewController {
    
    func performSignIn() {
        withAuthenticator { authenticator in
            authenticator.authenticate(username: username, password: password) { [weak self] authenticationResult in
                switch authenticationResult {
                case .authenticatedSuccessfully(let authenticatedUser):
                    self?.onUserDidSignInSuccessfully?(authenticatedUser)
                    
                case .noSuchUserFound:
                    self?.alertUser(of: .noSuchUserFound)
                    
                case .userWasRemoved:
                    self?.alertUser(of: .accountDeleted)
                    
                case .otherFactorRequired(otherFactor: _, let onAuthenticationComplete):
                    self?.alertUser(of: .todo(component: .mfa))
                    onAuthenticationComplete(.userRejectedRequest)
                    
                case .userCancelledAuthentication:
                    self?.broadState = .userIsEnteringInformation
                    
                case .unexpectedFailure:
                    self?.alertUser(of: .badAuthenticator)
                }
            }
        }
    }
    
    
    func performRegistration() {
        withAuthenticator { authenticator in
            authenticator.registerNewUser(username: username, password: password) { [weak self] registrationResult in
                switch registrationResult {
                case .registeredSuccessfully(let authenticatedUser):
                    self?.onUserDidSignInSuccessfully?(authenticatedUser)
                    
                case .userAlreadyRegistered:
                    self?.performSignIn()
                    
                case .otherFailure:
                    self?.alertUser(of: .badAuthenticator)
                }
            }
        }
    }
    
    
    func withAuthenticator(do function: (Authenticator) -> Void) {
        if let authenticator = self.authenticator {
            function(authenticator)
        }
        else {
            alertUser(of: .badAuthenticator)
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
