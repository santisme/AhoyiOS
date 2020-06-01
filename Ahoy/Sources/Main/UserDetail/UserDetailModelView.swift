//
//  UserDetailModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 04/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class UserDetailModelView {
    // MARK: - Private Properties
    weak private var view: UserDetailModelViewProtocol?
    private let userDetailRepository: LocalRepository
    
    // MARK: - Inits
    init(view: UserDetailModelViewProtocol?, userDetailRepository: LocalRepository) {
        self.view = view
        self.userDetailRepository = userDetailRepository
    }
    
    // MARK: - Public Methods
    func loadUserDetailModel() {
        do {
            guard let user = try userDetailRepository.loadLoggedUser(),
                let username = user.username
                else {
                    view?.logOut()
                    return
            }
            
            requestPrivateMessagesByUserId(username: username)
            
            view?.updateModel(userDetailModel: UserDetailModel(id: user.id, username: username, name: user.name, avatarTemplate: user.avatarTemplate, lastSeenAt: user.lastSeenAt, moderator: user.moderator, logged: true))
            
        } catch let error {
            view?.showError(message: "Error loading logged user \(error.localizedDescription)")
        }
    }
    
    private func downloadUserAvatar(avatarTemplate: String) {
        userDetailRepository.downloadUserAvatar(avatarTemplate: avatarTemplate, imageSize: .userDetailSize) { [weak self] result in
            switch result {
            case .success(let value):
                if let userAvatar = UIImage(data: value) {
                    self?.view?.updateAvatar(userAvatar: userAvatar)
                } else {
                    self?.view?.showError(message: "Avatar image is nil")
                }
                
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }
    
    private func requestPrivateMessagesByUserId(username: String) {
        userDetailRepository.fetchPrivateMessagesByUserId(username: username) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    let topicList = response.topicList.topics
                    try self?.userDetailRepository.deletePrivateMessagesByArchetype(archetype: .privateMessage)
                    try self?.userDetailRepository.savePrivateMessages(privateMessageList: topicList)
                    self?.view?.updatePrivateMessagesCount(count: topicList.count)
                    
                } catch (let error) {
                    self?.view?.showError(message: error.localizedDescription)
                }                
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }

    }
    
}

extension UserDetailModelView: UserDetailViewControllerDelegate {
    func loadUserDetailAvatar(avatarTemplate: String) {
        downloadUserAvatar(avatarTemplate: avatarTemplate)
    }
    
    func logOutButtonClicked(userDetailModel: UserDetailModel) {
        do {
            try userDetailRepository.logOutUserById(id: userDetailModel.id)
            view?.logOut()
        } catch let error {
            view?.showError(message: "User log out error")
            print("User log out error in CoreData: \(error.localizedDescription)")
        }
    }
}

protocol UserDetailModelViewProtocol: class {
    func showError(message: String)
    func showSuccess(message: String)
    func updateModel(userDetailModel: UserDetailModel)
    func updateAvatar(userAvatar: UIImage)
    func logOut()
    func updatePrivateMessagesCount(count: Int)
}
