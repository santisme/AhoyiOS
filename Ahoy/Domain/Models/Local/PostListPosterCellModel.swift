//
//  PostListPosterCellModel.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 18/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

struct PostListPosterCellModel {
    let userAvatar: UIImage?
    let username: String
}

extension PostListPosterCellModel: Hashable {
    static func == (lhs: PostListPosterCellModel, rhs: PostListPosterCellModel) -> Bool {
        return lhs.username == rhs.username
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(username)
        hasher.combine(username)
    }
}
