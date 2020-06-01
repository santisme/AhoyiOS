//
//  Post.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 13/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

// MARK: - Post
struct Post: Codable {
    let id: Int
    let name: String?
    let username: String
    let avatarTemplate: String
    let cooked: String?
    let blurb: String?
    let raw: String?
    let updatedAt: String?
    let createdAt: String?
    let topicId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case avatarTemplate = "avatar_template"
        case cooked
        case blurb
        case raw
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case topicId = "topic_id"
    }
}

extension Post: Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        return
            lhs.id == rhs.id
    }
}
