//
//  SignUpModel.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct SignUpModel: Codable {
    let name: String
    let email: String
    let password: String
//    let repeatedPassword: String
    let username: String
    let active: Bool? = true
    let approved: Bool? = true
}

struct SignUpModelWrapper {
    let signUpModel: SignUpModel
    let repeatedPassword: String
}
