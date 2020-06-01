//
//  Topic.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

@objcMembers
class Topic: NSObject, Codable {
    let id: Int
    let title: String
    let postsCount: Int
    let views: Int?
    let categoryId : Int?
    let posters: [Poster]?
    let createdAt: String?
    let archetype: String?
    let postStream: PostStream?
    let topicDetails: TopicDetails?
    let bumped: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case postsCount = "posts_count"
        case views
        case categoryId = "category_id"
        case posters
        case createdAt = "created_at"
        case archetype
        case postStream = "post_stream"
        case topicDetails = "details"
        case bumped
    }
    
    init(id: Int, title: String, postsCount: Int, views: Int?, categoryId: Int?, posters: [Poster]?, createdAt: String?, archetype: String?, postStream: PostStream?, topicDetails: TopicDetails?, bumped: Bool?) {
        self.id = id
        self.title = title
        self.postsCount = postsCount
        self.views = views
        self.categoryId = categoryId
        self.posters = posters
        self.createdAt = createdAt
        self.archetype = archetype
        self.postStream = postStream
        self.topicDetails = topicDetails
        self.bumped = bumped
    }
}

// MARK: - PostStream
struct PostStream: Codable {
    let posts: [Post]
}

enum TopicArchetype: String {
    case regular
    case privateMessage = "private_message"
}

struct TopicDetails: Codable {
    let topicCreatedBy: User

    enum CodingKeys: String, CodingKey {
        case topicCreatedBy = "created_by"
    }
}

//struct TopicCreatedBy: Codable {
//    let id: Int
//    let username: String
//    let avatarTemplate: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case username
//        case avatarTemplate = "avatar_template"
//    }
//}
