//
//  UserDetailModel.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct UserDetailModel {
    let id: Int
    let username: String
    let name: String?
    let avatarTemplate: String?
    let lastSeenAt: String? // "2020-02-25T23:19:53.817Z"
    let moderator: Bool?
    let logged: Bool
}
