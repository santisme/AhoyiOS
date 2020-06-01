//
//  SignInRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 27/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class SignInRepository: SignInRepositoryProtocol {
    
    // MARK: - Puplic Properties
    let apiSession: APISession
    
    // MARK: - Inits
    init(apiSession: APISession) {
        self.apiSession = apiSession
    }

    func signIn(signInModel: SignInModel, completion: @escaping (Result<SignInResponse, Error>) -> ()) {
        let request = SignInRequest(signInModel: signInModel)

        apiSession.send(request: request) {
            completion($0)
        }
    }
    
}
