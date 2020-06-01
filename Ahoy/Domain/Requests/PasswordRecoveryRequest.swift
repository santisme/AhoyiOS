//
//  PasswordRecoveryRequest.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 28/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct PasswordRecoveryRequest: APIRequest {
    typealias Response = PasswordRecoveryResponse
    
    let passwordRecoveryModel: PasswordRecoveryModel
    
    init(passwordRecoveryModel: PasswordRecoveryModel) {
        self.passwordRecoveryModel = passwordRecoveryModel
    }
    
    var method: Method {
        return .POST
    }
    
    var path: String {
        return "/session/forgot_password"
    }
    
    var parameters: [String : String] {
        return [:]
    }
    
    var body: [String : Any] {
        return ["login": passwordRecoveryModel.login]
    }
    
    var headers: [String : String] {
        return [:]
    }
    
}
