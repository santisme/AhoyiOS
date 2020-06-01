//
//  SignInRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 27/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct SignInRequest: APIRequest {
    typealias Response = SignInResponse
    
    let signInModel: SignInModel
    
    init(signInModel: SignInModel) {
        self.signInModel = signInModel
    }
    
    var method: Method {
        return .GET
    }
    
    var path: String {
        return "/users/\(signInModel.username).json"
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
