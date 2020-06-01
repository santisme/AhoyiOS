//
//  PrivateMessagesRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 13/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class PrivateMessagesRepository: PrivateMessagesRepositoryProtocol {
    // MARK: - Puplic Properties
    let apiSession: APISession
    
    // MARK: - Inits
    init(apiSession: APISession) {
        self.apiSession = apiSession
    }
    
    func fetchPrivateMessagesByUserId(username: String, completion: @escaping (Result<PrivateMessagesByUserResponse, Error>) -> ()) {
        let request = PrivateMessagesByUserRequest(username: username)
        
        apiSession.send(request: request) {
            completion($0)
        }
    }
    
}
