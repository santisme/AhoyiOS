//
//  PostRepositoryProtocol.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 15/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

protocol PostRepositoryProtocol {
    func fetchSingleTopic(topicId: Int, completion: @escaping (Result<SingleTopicResponse, Error>) -> ())
    func createNewPost(topicId: Int, raw: String, createdAt: String, completion: @escaping (Result<NewPostResponse, Error>) -> ())
}
