//
//  TopicCellModel.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 08/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

struct TopicCellModel {
    let id: Int
    let userImage: UIImage?
    let topicTitle: String
    let postsCount: Int
    let viewCount: Int
    let createdAt: String
    
}

extension TopicCellModel: Hashable {
    static func == (lhs: TopicCellModel, rhs: TopicCellModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(id)
    }
}
