//
//  SignUpModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

enum SignUpModelError: String, Error {
    case invalidEmail = "Invalid email"
    case passwordToShort = "Password too short, length must be 10 at least characters"
    case nonMatchingPasswords = "Passwords don't match"
    case usernameEmpty = "Username is empty"    
}

final class SignUpModelView {
    
    // MARK: - Private Properties
    weak private var view: SignUpModelViewProtocol?
    private let signUpRepository: LocalRepository
    
    // MARK: - Inits
    init(view: SignUpModelViewProtocol?, signUpRepository: LocalRepository) {
        self.view = view
        self.signUpRepository = signUpRepository
    }
    
    // MARK: - Public Methods
    func signUpModelIsValid(signUpModelWrapper: SignUpModelWrapper) -> Result<Bool, SignUpModelError> {
        
        switch usernameIsValid(username: signUpModelWrapper.signUpModel.username) {
        case .failure(let error):
            return .failure(error)
        case .success(_):
            break
        }
        
        switch emailIsValid(email: signUpModelWrapper.signUpModel.email) {
        case .failure(let error):
            return .failure(error)
        case .success(_):
            break
        }
        
        switch passwordIsValid(password: signUpModelWrapper.signUpModel.password) {
        case .failure(let error):
            return .failure(error)
        case .success(_):
            break
        }
        
        switch repeatPasswordIsValid(password: signUpModelWrapper.signUpModel.password, repeatedPassword: signUpModelWrapper.repeatedPassword) {
        case .failure(let error):
            return .failure(error)
        case .success(_):
            break
        }
        
        return .success(true)
        
    }
    
    func usernameIsValid(username: String) -> Result<Bool, SignUpModelError> {
        if (username.isEmpty) {
            return .failure(.usernameEmpty)
        }
        return .success(true)
    }
    
    func passwordIsValid(password: String) -> Result<Bool, SignUpModelError> {
        if (password.count < 10) {
            return .failure(.passwordToShort)
        }
        return .success(true)
    }
    
    func repeatPasswordIsValid(password: String, repeatedPassword: String) -> Result<Bool, SignUpModelError> {
        if (password != repeatedPassword) {
            return .failure(.nonMatchingPasswords)
        }
        return .success(true)
    }
    
    func emailIsValid(email: String) -> Result<Bool, SignUpModelError> {
        if (email.range(of: #"^\w+@\w+\.{1}\w{2,3}$"#, options: .regularExpression) == nil) {
            return .failure(.invalidEmail)
        }
        return .success(true)
    }
    
    
}

// MARK: - Extension SignUpModelView
extension SignUpModelView {
    
    private func signUp(signUpModel: SignUpModel) {
        signUpRepository.signUp(signUpModel: signUpModel) { [weak self] result in
            switch result {
            case .success(let value):
                if value.success {
                    self?.view?.showSuccess(message: "User account successfully created. Please review your email to activate it.")
                    self?.view?.clearForm()
                    self?.view?.navigateToSignIn()
                } else {
                    self?.view?.showError(message: value.message)
                }
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
        
    }

}

// MARK: - Extension SignUpViewControllerDelegate
extension SignUpModelView: SignUpViewControllerDelegate {
    func usernameEditingDidEnd(sender: DesignableTextField) {
        guard let username = sender.text else {
            return
        }
        switch usernameIsValid(username: username) {
        case .success(_):
            break
        case .failure(let error):
            view?.showError(message: error.rawValue)
        }
    }
    
    func passwordEditingDidEnd(sender: DesignableTextField) {
        guard let password = sender.text else {
            return
        }
        switch passwordIsValid(password: password) {
        case .success(_):
            break
        case .failure(let error):
            view?.showError(message: error.rawValue)
        }
        
    }
    
    func repeatedPasswordEditingDidEnd(passwordTextField: DesignableTextField, sender: DesignableTextField) {
        guard let repeatedPassword = sender.text,
            let password = passwordTextField.text else {
                return
        }
        switch repeatPasswordIsValid(password: password, repeatedPassword: repeatedPassword) {
        case .success(_):
            break
        case .failure(let error):
            view?.showError(message: error.rawValue)
        }
        
    }
    
    func emailEditingDidEnd(sender: DesignableTextField) {
        guard let email = sender.text else {
            return
        }
        switch emailIsValid(email: email) {
        case .success(_):
            break
        case .failure(let error):
            view?.showError(message: error.rawValue)
        }
        
    }
    
    func signUpClicked(signUpModelWrapper: SignUpModelWrapper) {
        switch signUpModelIsValid(signUpModelWrapper: signUpModelWrapper) {
        case .success(_):
            signUp(signUpModel: signUpModelWrapper.signUpModel)
        case .failure(let error):
            view?.showError(message: error.rawValue)
        }
    }
    
    func signInClicked() {
        view?.navigateToSignIn()
    }
 
    func passwordRecoveryClicked() {
        view?.navigateToPasswordRecovery()
    }
}

// MARK: - Protocol SignUpModelViewProtocol
protocol SignUpModelViewProtocol: class {
    func showError(message: String)
    func showSuccess(message: String)
    func clearForm()
    func navigateToSignIn()
    func navigateToPasswordRecovery()
    
}
