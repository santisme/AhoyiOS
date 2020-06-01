//
//  SignInModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 27/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

enum SignInModelError: String, Error {
    case usernameEmpty = "Username is empty"
    case passwordToShort = "Password too short, length must be 10 at least characters"
}

final class SignInModelView {
    // MARK: - Private Properties
    weak private var view: SignInModelViewProtocol?
    private let signInRepository: LocalRepository
    private var username: String? = nil
    private var password: String? = nil
    
    // MARK: - Inits
    init(view: SignInModelViewProtocol?, signInRepository: LocalRepository) {
        self.view = view
        self.signInRepository = signInRepository
    }
    
    // MARK: - Public Methods
    func signInModelIsValid(signInModel: SignInModel) -> Result<Bool, SignInModelError> {
        
        switch usernameIsValid(username: signInModel.username) {
        case .failure(let error):
            return .failure(error)
        case .success(_):
            break
        }
        
        switch passwordIsValid(password: signInModel.password) {
        case .failure(let error):
            return .failure(error)
        case .success(_):
            break
        }
        
        return .success(true)
    }
    
    func usernameIsValid(username: String) -> Result<Bool, SignInModelError> {
        if (username.isEmpty) {
            return .failure(.usernameEmpty)
        }
        return .success(true)
    }
    
    func passwordIsValid(password: String) -> Result<Bool, SignInModelError> {
        if (password.count < 10) {
            return .failure(.passwordToShort)
        }
        return .success(true)
    }
    
    // MARK: - Private Methods
    private func signIn(signInModel: SignInModel) {
        signInRepository.signIn(signInModel: signInModel) { [weak self] result in
            switch result {
            case .success(let value):
                if value.user?.username == signInModel.username {
                    self?.view?.showSuccess(message: "User logged")
                    
                    // Save User in Local Database
                    if let user = value.user {
                        do {
                            try self?.signInRepository.deleteUserBy(id: user.id)
                            try self?.signInRepository.saveLoggedUser(user: user)
                            self?.view?.navigateToMainViewController()
                        } catch let error {
                            self?.view?.showError(message: "Error saving logged user \(error.localizedDescription)")
                            
                        }
                    } else {
                        self?.view?.showError(message: "Error user returned in response is nil")
                    }
                    
                } else {
                    self?.view?.showError(message: "User \(signInModel.username) doesn't exist")
                }
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
        
    }
    
    private func updatePasswordAndSignIn(signInModel: SignInModel) {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: signInModel.username, accessGroup: KeychainConfiguration.accessGroup)
            let oldPassword = try passwordItem.readPassword()
            if signInModel.password != oldPassword {
                savePasswordInKeychain()
                //                view?.askForSavingCredentialInKeychain { [weak self] in
                //                    self?.signIn(signInModel: signInModel)
                //                }
            } else {
                signIn(signInModel: signInModel)
            }
        } catch KeychainPasswordItem.KeychainError.noPassword {
            savePasswordInKeychain()
            //            view?.askForSavingCredentialInKeychain { [weak self] in
            //                self?.signIn(signInModel: signInModel)
            //            }
        } catch (let error) {
            print("\(error)")
        }
    }
}

// MARK: - Extension to implement SignInViewControllerDelegate
extension SignInModelView: SignInViewControllerDelegate {
    func signInClicked(signInModel: SignInModel) {
        switch signInModelIsValid(signInModel: signInModel) {
        case .success(_):
            updatePasswordAndSignIn(signInModel: signInModel)
        //            signIn(signInModel: signInModel)
        case .failure(let error):
            view?.showError(message: error.rawValue)
        }
    }
    
    func signUpClicked() {
        view?.navigateToSignUp()
    }
    
    func passwordRecoveryClicked() {
        view?.navigateToPasswordRecovery()
    }
    
    func usernameEditingDidEnd(sender: DesignableTextField) {
        guard let username = sender.text else {
            return
        }
        switch usernameIsValid(username: username) {
        case .success(_):
            //            do {
            self.username = username
            do {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
                view?.passwordFound(password: try passwordItem.readPassword())
            } catch (let error) {
                print("Error: \(error)")
            }
            
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
            self.password = password
            break
        case .failure(let error):
            view?.showError(message: error.rawValue)
        }
    }
    
    func lookForActiveLogin() {
        do {
            if let _ = try signInRepository.loadLoggedUser() {
                view?.navigateToMainViewController()
            }
        }catch let error {
            view?.showError(message: "Error checking if there is an active login")
            print("Error calling loadLoggedUser(): \(error.localizedDescription)")
        }
    }
    
    func savePasswordInKeychain() {
        do {
            // This is a new account, create a new keychain item with the account name.
            if let username = self.username, let password = self.password {
                let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: username, accessGroup: KeychainConfiguration.accessGroup)
                
                // Save the password for the new item.
                try passwordItem.savePassword(password)
            }
        } catch (let error) {
            print("Error: \(error)")
        }
    }
}

// MARK: - Protocol SignInModelViewProtocol
protocol SignInModelViewProtocol: class {
    func showError(message: String)
    func showSuccess(message: String)
    func clearForm()
    func navigateToSignUp()
    func navigateToMainViewController()
    func navigateToPasswordRecovery()
    func passwordFound(password: String)
    func askForSavingCredentialInKeychain(completion: @escaping () -> ())
}
