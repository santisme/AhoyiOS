//
//  PasswordRecoveryRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 28/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class PasswordRecoveryRepository: PasswordRecoveryRepositoryProtocol {
    
    // MARK: - Puplic Properties
    let apiSession: APISession
    
    // MARK: - Inits
    init(apiSession: APISession) {
        self.apiSession = apiSession
    }

    func resetPassword(passwordRecoveryModel: PasswordRecoveryModel, completion: @escaping (Result<PasswordRecoveryResponse, Error>) -> ()) {
        let request = PasswordRecoveryRequest(passwordRecoveryModel: passwordRecoveryModel)

        apiSession.send(request: request) {
            completion($0)
        }
    }
    
}
