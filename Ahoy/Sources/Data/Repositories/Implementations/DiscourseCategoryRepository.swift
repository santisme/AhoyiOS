//
//  DiscourseCategoryRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 06/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct DiscourseCategoryRepository: DiscourseCategoryRepositoryProtocol {
    // MARK: - Properties
    let apiSession: APISession
    
    // MARK: - Inits
    init(apiSession: APISession) {
        self.apiSession = apiSession
    }
    
    // MARK: - Methods
    func fetchDiscourseCategoryList(completion: @escaping (Result<DiscourseCategoryListResponse, Error>) -> ()) {
        let categoryListRequest = CategoryListRequest()
        
        apiSession.send(request: categoryListRequest) {
            completion($0)
        }
        
    }
}
