//
//  TopTopicsRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 09/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class TopTopicsRequest: APIRequest {
    typealias Response = TopTopicsResponse
    
    var method: Method {
        return .GET
    }
    
    var path: String {
        return "/top.json"
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
