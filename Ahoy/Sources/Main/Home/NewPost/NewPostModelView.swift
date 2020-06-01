//
//  NewPostModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 22/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class NewPostModelView {
    // MARK: - Private Properties
    private let postTextMinLength = 20
    weak private var view: NewPostModelViewProtocol?
    private let postRepository: LocalRepository
    private let topicId: Int
    
    // MARK: - Inits
    init(view: NewPostModelViewProtocol? = nil, postRepository: LocalRepository, topicId: Int) {
        self.view = view
        self.postRepository = postRepository
        self.topicId = topicId
    }
    
    // MARK: - Private Methods
    private func isValidPost(postContent: String) -> Bool {
        return postContent.count > postTextMinLength
    }
    
    private func sendPost(postContent: String) {
        if (NetworkReachability.isNetworkAvailable()) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyyThh:mm:ssZ"
            postRepository.createNewPost(topicId: topicId, raw: postContent, createdAt: dateFormatter.string(from: Date())) { [weak self] response in
                switch response {
                case .success(let value):
                    if value.errors == nil {
                        self?.view?.showSuccess(message: "Post successfully created")
                        self?.view?.dismissView()
                    } else {
                        if let errors = value.errors {
                            if errors.count > 0 {
                                self?.view?.showError(message: "Ooops, something went wrong: \(value.errors?.first ?? "Unknown")")
                            }
                        }
                    }
                case .failure(let error):
                    self?.view?.showSuccess(message: "Ooops, something went wrong creating the post")
                    print("Error creating post: \(error.localizedDescription)")
                }
            }
        } else {
            view?.showError(message: "App is working offline. You cannot create any post rigth now.")
        }
    }
}

extension NewPostModelView: NewPostViewControllerDelegate {
    
    func sendPostClicked(postContent: String?) {
        if let postContent = postContent {
            if isValidPost(postContent: postContent) {
                sendPost(postContent: postContent)
            } else {
                view?.showError(message: "The number of characters of the post must be at least 20.")
            }
        }
    }
    
    func cancelClicked() {
        view?.dismissView()
    }
    
}

// MARK: - Protocol NewPostModelViewProtocol definition
protocol NewPostModelViewProtocol: class {
    func showError(message: String)
    func showSuccess(message: String)
    func dismissView()
}
