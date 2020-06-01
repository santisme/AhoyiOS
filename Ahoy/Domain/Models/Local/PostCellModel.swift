//
//  PostCellModel.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 15/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

struct PostCellModel {
    let userImage: UIImage?
    let username: String
    let postContent: String
    let updatedAt: String
    
}

struct PostCellModelWrapper {
    let postCellModel: PostCellModel
    let topicId: Int
}
