//
//  PrivateMessagesRepositoryProtocol.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 13/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

protocol PrivateMessagesRepositoryProtocol {
    func fetchPrivateMessagesByUserId(username: String, completion: @escaping (Result<PrivateMessagesByUserResponse, Error>) -> ())
}
