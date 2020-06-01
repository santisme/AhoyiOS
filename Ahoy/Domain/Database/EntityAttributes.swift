//
//  EntityAttributes.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

typealias PrivateMessageCDAttr = TopicCDAttr
enum TopicCDAttr: String {
    case id
    case title
    case categoryId
    case views
    case postsCount
    case topicDetails
    case postStream
    case posters
    case createdAt
    case archetype
    case bumped
}

enum PostStreamCDAttr: String {
    case posts
    case topic
}

enum PostCDAttr: String {
    case id
    case name
    case username
    case cooked
    case blurb
    case raw
    case updatedAt
    case createdAt
    case avatarTemplate
    case postStream
    case topicId
}

enum UserCDAttr: String {
    case id
    case username
    case name
    case avatarTemplate
    case lastSeenAt
    case moderator
    case poster
    case logged
}

enum PosterCDAttr: String {
    case posterDescription
    case userId
}

enum DiscourseCategoryCDAttr: String {
    case id
    case name
    case color
    case textColor
}

enum TopicDetailsCDAttr: String {
    case createdBy
}

enum CreatedByCDAttr: String {
    case id
    case username
}

enum UserAvatarCDAttr: String {
    case userId
    case avatarTemplateImage
}
