//
//  TopicFilterModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 06/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class TopicFilterModelView {
    // MARK: - Private Properties
    weak private var view: TopicFilterModelViewProtocol?
    private let localRepository: LocalRepository
    private var categoryList: [DiscourseCategory]? = []
    private var navigation: TopicFilterModelViewNavigation
    
    // MARK: - Inits
    init(view: TopicFilterModelViewProtocol? = nil, navigation: TopicFilterModelViewNavigation, localRepository: LocalRepository) {
        self.view = view
        self.navigation = navigation
        self.localRepository = localRepository
    }
}

extension TopicFilterModelView: TopicFilterViewControllerDelegate {
    
    func viewDidLoad() {
        do {
            if let response = try localRepository.loadDiscourseCategoryListResponse() {
                view?.updateDiscourseCategoryList(discourseCategoryList: response.discourseCategoryList.discourseCategories)
            } else {
                view?.showError(message: "Error loading discourse catefories from database")
            }
        } catch let error {
            view?.showError(message: error.localizedDescription)
        }
        
        if (NetworkReachability.isNetworkAvailable()) {
            localRepository.fetchDiscourseCategoryList { [weak self] result in
                switch result {
                case .success(let value):
                    do {
                        try self?.localRepository.initDiscourseCategoryDefaultData()
                        try self?.localRepository.saveDiscourseCategoryList(discourseCategoryList: value.discourseCategoryList.discourseCategories)
                    } catch let error {
                        self?.view?.showError(message: error.localizedDescription)
                    }
                    self?.view?.updateDiscourseCategoryList(discourseCategoryList: value.discourseCategoryList.discourseCategories)
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        }
    }

    func refreshDiscourseCategoryList() {
        if (NetworkReachability.isNetworkAvailable()) {
            localRepository.fetchDiscourseCategoryList { [weak self] result in
                switch result {
                case .success(let value):
                    do {
                        try self?.localRepository.initDiscourseCategoryDefaultData()
                        try self?.localRepository.saveDiscourseCategoryList(discourseCategoryList: value.discourseCategoryList.discourseCategories)
                    } catch let error {
                        self?.view?.showError(message: error.localizedDescription)
                    }
                    self?.view?.updateDiscourseCategoryList(discourseCategoryList: value.discourseCategoryList.discourseCategories)
                case .failure(let error):
                    self?.view?.showError(message: error.localizedDescription)
                }
            }
        } else {
            do {
                if let response = try localRepository.loadDiscourseCategoryListResponse() {
                    view?.updateDiscourseCategoryList(discourseCategoryList: response.discourseCategoryList.discourseCategories)
                } else {
                    view?.showError(message: "Error loading discourse catefories from database")
                }
            } catch let error {
                view?.showError(message: error.localizedDescription)
            }
        }
    }
    
    func didTapDiscourseCategory(discourseCategory: DiscourseCategory) {
        navigation.didTapDiscourseCategory(discourseCategory: discourseCategory)
    }
    
    func didTapTopicFilter(topicFilter: TopicFilterType) {
        navigation.didTapTopicFilter(topicFilter: topicFilter)
    }
    
}

protocol TopicFilterModelViewProtocol: class {
    func updateDiscourseCategoryList(discourseCategoryList: [DiscourseCategory])
    func showError(message: String)
}


protocol TopicFilterModelViewNavigation: class {
    func didTapDiscourseCategory(discourseCategory: DiscourseCategory)
    func didTapTopicFilter(topicFilter: TopicFilterType)
}
