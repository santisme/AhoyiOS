//
//  SingleTopicResponse.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 15/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

// MARK: - SingleTopicResponse
struct SingleTopicResponse: Codable {
    let postStream: PostStream?
    let id: Int
    let title: String
    let categoryId: Int?
    let details: TopicDetails?
    let suggestedTopics: [Topic]?
    let views: Int
    
    enum CodingKeys: String, CodingKey {
        case postStream = "post_stream"
        case id
        case title
        case categoryId = "category_id"
        case details
        case suggestedTopics = "suggested_topics"
        case views
    }
}
