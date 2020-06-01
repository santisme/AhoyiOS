//
//  SearchRepositoryProtocol.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

protocol SearchRepositoryProtocol {
    func searchTerm(term: String, completion: @escaping (Result<SearchResponse, Error>) -> ())
}
