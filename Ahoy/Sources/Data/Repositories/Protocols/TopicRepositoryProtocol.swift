//
//  TopicRepositoryProtocol.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 08/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

protocol TopicRepositoryProtocol {
    func fetchLatestTopics(order: TopicsOrder?, ascending: Bool?, page: Int?, completion: @escaping (Result<LatestTopicsResponse, Error>) -> ())
    func fetchTopTopics(completion: @escaping (Result<LatestTopicsResponse, Error>) -> ())
    func createNewTopic(title: String, raw: String, categoryId: Int?, createdAt: String, completion: @escaping (Result<NewTopicResponse, Error>) -> ())
}
