//
//  NewPostResponse.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 22/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

typealias NewTopicResponse = NewPostResponse
typealias NewPrivateMessageResponse = NewPostResponse

// MARK: - NewPostResponse
struct NewPostResponse: Codable {
    let errors: [String]?
    let id: Int?
    let topicId: Int?
    let raw: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case errors
        case id
        case topicId = "topic_id"
        case raw
        case createdAt = "created_at"
    }
}
