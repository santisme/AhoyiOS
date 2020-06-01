//
//  MainModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 05/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class MainModelView {
    // MARK: - Private Properties
    weak private var view: MainModelViewProtocol?
    private let userDetailRepository: LocalRepository
    
    // MARK: - Inits
    init(view: MainModelViewProtocol? = nil, userDetailRepository: LocalRepository) {
        self.view = view
        self.userDetailRepository = userDetailRepository
    }
}

extension MainModelView: MainViewControllerDelegate {
    func lookForActiveLogin() {
        do {
            if (try userDetailRepository.loadLoggedUser()) == nil {
                view?.noActiveLoginFound()
            } else {
                view?.showSuccess(message: "User logged")
                
            }
        } catch let error {
            view?.showError(message: "Error looking for active login")
            print("Error calling loadLoggedUser(): \(error.localizedDescription)")
        }
    }
}

protocol MainModelViewProtocol: class {
    func noActiveLoginFound()
    func showError(message: String)
    func showSuccess(message: String)
}
