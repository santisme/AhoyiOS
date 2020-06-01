//
//  UserAvatarRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 04/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct UserAvatarRequest: APIRequestData {    
    let avatarTemplate: String
    
    init(avatarTemplate: String) {
        self.avatarTemplate = avatarTemplate
    }
    
    var method: Method {
        return .GET
    }
    
    var path: String {
        return "\(avatarTemplate)"
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
