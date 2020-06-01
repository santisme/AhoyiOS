//
//  Poster.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct Poster: Codable {
    let description: String // IF matches to "Original Poster"
    let userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case description
        case userId = "user_id"
    }
}
