//
//  NewTopicModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 23/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class NewTopicModelView {
    // MARK: - Private Properties
    private let titleTextMinLength = 15
    private let rawMinLength = 20
    weak private var view: NewTopicModelViewProtocol?
    private let topicRepository: LocalRepository
    
    enum NewTopicFieldError: String {
        case titleLength = "Topic title requires 15 at least"
        case rawLength = "Topic content requires 20 at least"
        case discourseCategoryEmpty = "Topic must belong to a Discourse Category"
    }
    
    // MARK: - Inits
    init(view: NewTopicModelViewProtocol? = nil, topicRepository: LocalRepository) {
        self.view = view
        self.topicRepository = topicRepository
    }
    
    // MARK: - Private Methods
    private func isTitleValid(title: String) -> Bool {
        return title.count > self.titleTextMinLength
    }
    
    private func isRawValid(raw: String) -> Bool {
        return raw.count > rawMinLength
    }
    
    private func isValidNewTopic(newTopicModel: NewTopicModel) -> (Bool, NewTopicFieldError?) {
        if !isTitleValid(title: newTopicModel.title) { return (false, .titleLength) }
        if !isRawValid(raw: newTopicModel.raw) { return (false, .rawLength) }
        if newTopicModel.discourseCategory == nil { return (false, .discourseCategoryEmpty) }
        
        return (true, nil)
    }
    
    private func createNewTopic(newTopicModel: NewTopicModel) {
        if (NetworkReachability.isNetworkAvailable()) {
            topicRepository.createNewTopic(title: newTopicModel.title,
                                           raw: newTopicModel.raw,
                                           categoryId: newTopicModel.discourseCategory?.id,
                                           createdAt: newTopicModel.createdAt) { [weak self] result in
                                            switch result {
                                            case .success(let value):
                                                if value.errors == nil {
                                                    self?.view?.showSuccess(message: "Topic successfully created")
                                                    self?.view?.dismissView()
                                                } else {
                                                    if let errors = value.errors, errors.count > 0 {
                                                        self?.view?.showError( message: "Ooops, something went wrong: \(errors.first ?? "Unknown error")")
                                                    }
                                                }
                                            case .failure(let error):
                                                self?.view?.showError(message: "Error creating new topic: \(error.localizedDescription)")
                                            }
            }
        } else {
            view?.showError(message: "App is working offline. You cannot create any topic rigth now.")
        }
    }
    
}

// MARK: - Extension NewTopicViewControllerDelegate protocol implementation
extension NewTopicModelView: NewTopicViewControllerDelegate {
    func sendTopicClicked(newTopicModel: NewTopicModel) {
        let result = isValidNewTopic(newTopicModel: newTopicModel)
        if result.0 {
            createNewTopic(newTopicModel: newTopicModel)
        } else {
            view?.showError(message: result.1?.rawValue ?? "Unknown error")
        }
    }
    
    func cancelClicked() {
        view?.dismissView()
    }
    
    func discourseCategoryClicked() {
        view?.navigateToChooseDiscourseCategory()
    }
    
}

// MARK: - Protocol NewTopicModelViewProtocol definition
protocol NewTopicModelViewProtocol: class {
    //    func updateModel(model: [DiscourseCategory])
    func showError(message: String)
    func showSuccess(message: String)
    func dismissView()
    func navigateToChooseDiscourseCategory()
}
