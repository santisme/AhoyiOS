//
//  DiscourseCategoryRepositoryProtocol.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 06/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

protocol DiscourseCategoryRepositoryProtocol {
    func fetchDiscourseCategoryList(completion: @escaping (Result<DiscourseCategoryListResponse, Error>) -> ())
//    func fetchTopicsInCategory(id: Int, completion: @escaping (Result<TopicsInCategoryResponse, Error>) -> ())
}
