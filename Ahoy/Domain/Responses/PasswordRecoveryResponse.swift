//
//  PasswordRecoveryResponse.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 28/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct PasswordRecoveryResponse: Codable {
    let success: String
    let userFound: Bool
    
    enum CodingKeys: String, CodingKey {
        case success
        case userFound = "user_found"
    }
}
