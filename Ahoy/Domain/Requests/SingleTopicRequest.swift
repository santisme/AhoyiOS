//
//  SingleTopicRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 15/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct SingleTopicRequest: APIRequest {
    typealias Response = SingleTopicResponse
    
    let topicId: Int
    
    init(topicId: Int) {
        self.topicId = topicId
    }
    
    var method: Method {
        return .GET
    }
    
    var path: String {
        return "/t/\(topicId).json"
    }
    
    var parameters: [String : String] {
        return [:]
    }
    
    var body: [String : Any] {
        return [:]
    }
    
    var headers: [String : String] {
        return [:]
    }
    
}
