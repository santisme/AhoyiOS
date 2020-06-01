//
//  PostRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 15/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class PostRepository: PostRepositoryProtocol {

    // MARK: - Puplic Properties
    let apiSession: APISession
    
    // MARK: - Inits
    init(apiSession: APISession) {
        self.apiSession = apiSession
    }
    
    func fetchSingleTopic(topicId: Int, completion: @escaping (Result<SingleTopicResponse, Error>) -> ()) {
        let request = SingleTopicRequest(topicId: topicId)
        
        apiSession.send(request: request) {
            completion($0)
        }
    }
    
    func createNewPost(topicId: Int, raw: String, createdAt: String, completion: @escaping (Result<NewPostResponse, Error>) -> ()) {
        let request = NewPostRequest(topicId: topicId, raw: raw, createdAt: createdAt)
        
        apiSession.send(request: request) {
            completion($0)
        }
    }
    
}
