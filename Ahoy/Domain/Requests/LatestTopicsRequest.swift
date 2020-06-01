//
//  LatestTopicsRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

enum TopicsOrder: String, Codable {
    case byDefault = "default"
    case created = "created"
    case activity = "activity"
    case views = "views"
    case posts = "posts"
    case category = "category"
    case likes = "likes"
    case opLikes = "op_likes"
    case posters = "posters"
}

struct LatestTopicsRequest: APIRequest {
    typealias Response = LatestTopicsResponse
    
    let order: TopicsOrder
    let ascending: Bool
    let page: Int
    
    init(order: TopicsOrder = .byDefault, ascending: Bool = false, page: Int = 1) {
        self.order = order
        self.ascending = ascending
        self.page = page
    }
    
    var method: Method {
        return .GET
    }
    
    var path: String {
        return "/latest.json"
    }
    
    var parameters: [String : String] {
        return ["order": order.rawValue,
                "ascending": String(ascending),
                "page": String(page)]
    }
    
    var body: [String : Any] {
        return [:]
    }
    
    var headers: [String : String] {
        return [:]
    }
    
}


