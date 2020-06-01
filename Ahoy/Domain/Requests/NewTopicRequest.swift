//
//  NewTopicRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 24/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct NewTopicRequest: APIRequest {
    typealias Response = NewTopicResponse
    
    let title: String
    let raw: String
    let category: Int?
    let createdAt: String
    
    init(title: String, raw: String, categoryId: Int? = nil, createdAt: String) {
        self.title = title
        self.raw = raw
        self.category = categoryId
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
        if self.category == nil {
            return [ "title": title ,
                     "raw": raw,
                     "created_at": createdAt ]
        } else {
            return [ "title": title ,
                     "raw": raw,
                     "category": category ?? "nil",
                     "created_at": createdAt ]
        }
    }
    
    var headers: [String : String] {
        return [:]
    }
    
}
