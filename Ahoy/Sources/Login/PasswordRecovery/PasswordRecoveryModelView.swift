//
//  PasswordRecoveryModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 27/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

enum PasswordRecoveryModelError: String, Error {
    case loginEmpty = "Username is empty"
}

final class PasswordRecoveryModelView {
    // MARK: - Private Properties
    weak private var view: PasswordRecoveryModelViewProtocol?
    private let passwordRecoveryRepository: LocalRepository
    
    // MARK: - Inits
    init(view: PasswordRecoveryModelViewProtocol?, passwordRecoveryRepository: LocalRepository) {
        self.view = view
        self.passwordRecoveryRepository = passwordRecoveryRepository
    }
    
    // MARK: - Public Methods
    func passwordRecoveryModelIsValid(passwordRecoveryModel: PasswordRecoveryModel) -> Result<Bool, PasswordRecoveryModelError> {
        
        switch loginIsValid(login: passwordRecoveryModel.login) {
        case .failure(let error):
            return .failure(error)
        case .success(_):
            break
        }
        
        return .success(true)
    }
    
    func loginIsValid(login: String) -> Result<Bool, PasswordRecoveryModelError> {
        if (login.isEmpty) {
            return .failure(.loginEmpty)
        }
        return .success(true)
    }
    
    // MARK: - Private Methods
    private func resetPassword(passwordRecoveryModel: PasswordRecoveryModel) {
        
        passwordRecoveryRepository.resetPassword(passwordRecoveryModel: passwordRecoveryModel) { [weak self] result in
            switch result {
            case .success(let value):
                if (value.userFound) {
                    self?.view?.showSuccess(message: "Email to reset password successfully sent")
                    self?.view?.clearForm()
                    self?.view?.dismissViewController()
                } else {
                    self?.view?.showError(message: "User \(passwordRecoveryModel.login) doesn't exist")
                }
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }

}

extension PasswordRecoveryModelView: PasswordRecoveryViewControllerDelegate {
    func resetPasswordClicked(passwordRecoveryModel: PasswordRecoveryModel) {
        switch passwordRecoveryModelIsValid(passwordRecoveryModel: passwordRecoveryModel) {
        case .success(_):
            resetPassword(passwordRecoveryModel: passwordRecoveryModel)
        case .failure(let error):
            view?.showError(message: error.rawValue)
        }
    }
    
    func cancelClicked() {
        view?.dismissViewController()
    }
    
}

// MARK: - Protocol PasswordRecoveryModelViewProtocol
protocol PasswordRecoveryModelViewProtocol: class {
    func showError(message: String)
    func showSuccess(message: String)
    func clearForm()
    func dismissViewController()
}
