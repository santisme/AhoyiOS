//
//  SignUpRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 27/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class SignUpRepository: SignUpRepositoryProtocol {
    
    // MARK: - Puplic Properties
    let apiSession: APISession
    
    // MARK: - Inits
    init(apiSession: APISession) {
        self.apiSession = apiSession
    }

    func signUp(signUpModel: SignUpModel, completion: @escaping (Result<SignUpResponse, Error>) -> ()) {
        let request = SignUpRequest(signUpModel: signUpModel)

        apiSession.send(request: request) {
            completion($0)
        }
    }
    
}
