//
//  PostListHeaderCellModel.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 18/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct PostListHeaderCellModel {
    let topicTitle: String
    let postsCount: Int
    let viewCount: Int
    let updatedAt: String
    let topicText: String
    let posterList: [PostListPosterCellModel]
}
