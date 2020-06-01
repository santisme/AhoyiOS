//
//  SearchRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class SearchRepository: SearchRepositoryProtocol {

    // MARK: - Puplic Properties
    let apiSession: APISession
    
    // MARK: - Inits
    init(apiSession: APISession) {
        self.apiSession = apiSession
    }
    
    func searchTerm(term: String, completion: @escaping (Result<SearchResponse, Error>) -> ()) {
        let request = SearchRequest(term: term)
        
        apiSession.send(request: request) {
            completion($0)
        }
    }

}
