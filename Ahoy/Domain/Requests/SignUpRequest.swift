//
//  SignUpRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct SignUpRequest: APIRequest {   
    typealias Response = SignUpResponse
    
    let signUpModel: SignUpModel
    
    init(signUpModel: SignUpModel) {
        self.signUpModel = signUpModel
    }
    
    var method: Method {
        return .POST
    }
    
    var path: String {
        return "/users"
    }
    
    var parameters: [String : String] {
        return [:]
    }
    
    var body: [String : Any] {
        return [
            "name": signUpModel.name,
            "email": signUpModel.email,
            "password": signUpModel.password,
            "username": signUpModel.username,
            "active": signUpModel.active ?? true,
            "approved": signUpModel.approved ?? true
        ]
    }
    
    var headers: [String : String] {
        return [:]
    }
    
}
