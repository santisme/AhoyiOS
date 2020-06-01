//
//  CategoryListRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 06/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct CategoryListRequest: APIRequest {
    typealias Response = DiscourseCategoryListResponse
    
    var method: Method {
        return .GET
    }
    
    var path: String {
        return "categories.json"
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


