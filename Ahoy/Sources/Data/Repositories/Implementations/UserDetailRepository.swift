//
//  UserDetailRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 04/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

enum UserAvatarSize: String {
    case topicCellSize = "64"
    case userDetailSize = "512"
}

final class UserDetailRepository: UserDetailRepositoryProtocol {
    // MARK: - Puplic Properties
    let apiSession: APISession
    
    // MARK: - Inits
    init(apiSession: APISession) {
        self.apiSession = apiSession
    }
    
    func downloadUserAvatar(avatarTemplate: String, imageSize: UserAvatarSize, completion: @escaping (Result<Data, Error>) -> ()) {
        let avatarTemplateUrlString = avatarTemplate.replacingOccurrences(of: "{size}",
                                                                          with: "\(imageSize.rawValue)")
        let urlString = "\(avatarTemplateUrlString)"
        let request = UserAvatarRequest(avatarTemplate: urlString)
        
        apiSession.send(request: request) {
            completion($0)
        }
    }
}
