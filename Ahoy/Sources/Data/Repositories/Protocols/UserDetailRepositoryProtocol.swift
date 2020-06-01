//
//  UserDetailRepositoryProtocol.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 04/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

protocol UserDetailRepositoryProtocol {
    func downloadUserAvatar(avatarTemplate: String, imageSize: UserAvatarSize, completion: @escaping (Result<Data, Error>) -> ())
    
}
