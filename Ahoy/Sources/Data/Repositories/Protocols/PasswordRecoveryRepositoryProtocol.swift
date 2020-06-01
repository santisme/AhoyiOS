//
//  PasswordRecoveryRepositoryProtocol.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 28/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

protocol PasswordRecoveryRepositoryProtocol {
    func resetPassword(passwordRecoveryModel: PasswordRecoveryModel, completion: @escaping (Result<PasswordRecoveryResponse, Error>) -> ())
}
