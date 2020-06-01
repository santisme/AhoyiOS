//
//  TopicRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 08/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class TopicRepository: TopicRepositoryProtocol {

    // MARK: - Puplic Properties
    let apiSession: APISession
    
    // MARK: - Inits
    init(apiSession: APISession) {
        self.apiSession = apiSession
    }
    
    func fetchLatestTopics(order: TopicsOrder? = .byDefault, ascending: Bool? = false, page: Int? = 1, completion: @escaping (Result<LatestTopicsResponse, Error>) -> ()) {
        let request = LatestTopicsRequest(order: order!, ascending: ascending!, page: page!)
        
        apiSession.send(request: request) {
            completion($0)
        }
    }
    
    func fetchTopTopics(completion: @escaping (Result<LatestTopicsResponse, Error>) -> ()) {
        let request = TopTopicsRequest()
        
        apiSession.send(request: request) {
            completion($0)
        }
    }
    
    func createNewTopic(title: String, raw: String, categoryId: Int?, createdAt: String, completion: @escaping (Result<NewTopicResponse, Error>) -> ()) {
        let newTopicRequest = NewTopicRequest(title: title, raw: raw, categoryId: categoryId, createdAt: createdAt)
        
        apiSession.send(request: newTopicRequest) {
            completion($0)
        }
    }
    
}
