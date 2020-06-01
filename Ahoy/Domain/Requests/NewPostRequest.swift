//
//  NewPostRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 22/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct NewPostRequest: APIRequest {
    typealias Response = NewPostResponse
    
    let topicId: Int
    let raw: String
    let createdAt: String
    
    init(topicId: Int, raw: String, createdAt: String) {
        self.topicId = topicId
        self.raw = raw
        self.createdAt = createdAt
    }
    
    var method: Method {
        return .POST
    }
    
    var path: String {
        return "/posts.json"
    }
    
    var parameters: [String : String] {
        return [:]
    }
    
    var body: [String : Any] {
        return [ "topic_id": topicId ,
                 "raw": raw,
                 "created_at": createdAt ]
    }
    
    var headers: [String : String] {
        return [:]
    }
    
}
