//
//  SearchResponse.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    let posts: [Post]
    let topics: [Topic]?
}
