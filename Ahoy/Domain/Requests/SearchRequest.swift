//
//  SearchRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct SearchRequest: APIRequest {
    typealias Response = SearchResponse
    
    let term: String
    
    init(term: String) {
        self.term = term
    }
    
    var method: Method {
        return .GET
    }
    
    var path: String {
        return "/search/query.json"
    }
    
    var parameters: [String : String] {
        return ["term": term]
    }
    
    var body: [String : Any] {
        return [:]
    }
    
    var headers: [String : String] {
        return [:]
    }
    
}
