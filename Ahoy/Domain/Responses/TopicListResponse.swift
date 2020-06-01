//
//  TopicListResponse.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

typealias LatestTopicsResponse = TopicListResponse
typealias PrivateMessagesByUserResponse = TopicListResponse
typealias TopTopicsResponse = TopicListResponse

// MARK: - TopicList
struct TopicListResponse: Codable {
    let users: [User]
    let topicList: TopicList
    
    enum CodingKeys: String, CodingKey {
        case users
        case topicList = "topic_list"
    }
}

struct TopicList: Codable {
    let moreTopicsUrl: String?
    let topics: [Topic]
    
    enum CodingKeys: String, CodingKey {
        case moreTopicsUrl = "more_topics_url"
        case topics
    }
}
