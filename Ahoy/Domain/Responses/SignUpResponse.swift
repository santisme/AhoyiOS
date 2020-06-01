//
//  SignUpResponse.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct SignUpResponse: Codable {
    let success: Bool
    let active: Bool?
    let message: String
    let userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case success
        case active
        case message
        case userId = "user_id"
    }
}
