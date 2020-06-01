//
//  SignInResponse.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 27/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct SignInResponse: Codable {
    let user: User?
    let errorType: String?
    
    enum CodingKeys: String, CodingKey {
        case user
        case errorType = "error_type"
    }

}

// MARK: - User
struct User: Codable {
    let id: Int
    let username: String?
    let name: String?
    let avatarTemplate: String?
    let lastSeenAt: String? // "2020-02-25T23:19:53.817Z"
    let moderator: Bool?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case avatarTemplate = "avatar_template"
        case lastSeenAt = "last_seen_at"
        case moderator
    }
    
}

extension User: Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(id)
    }
}
