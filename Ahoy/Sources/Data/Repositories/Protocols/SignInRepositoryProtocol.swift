//
//  SignInRepositoryProtocol.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 27/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

protocol SignInRepositoryProtocol {
    func signIn(signInModel: SignInModel, completion: @escaping (Result<SignInResponse, Error>) -> ())
}
