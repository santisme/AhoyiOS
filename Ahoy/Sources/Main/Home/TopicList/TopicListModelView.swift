//
//  TopicListModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 07/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class TopicListModelView {
    // MARK: - Private Properties
    weak private var view: TopicListModelViewDelegate?
    private let topicRepository: LocalRepository
//    private let topicsPerPage: Int = 30
    private var pageNumber: Int = 0
    private var isNetworkConnectionNotified = false
    
    // MARK: - Inits
    init(view: TopicListModelViewDelegate? = nil, topicRepository: LocalRepository) {
        self.view = view
        self.topicRepository = topicRepository
    }
    
    private func joinResponseToModel(currentModel: [TopicCellModel], response: TopicListResponse) {
        let responseTopics = response.topicList.topics
        
        var joinnedModelSet = Set<TopicCellModel>()
        currentModel.forEach {
            joinnedModelSet.insert(TopicCellModel(id: $0.id, userImage: $0.userImage, topicTitle: $0.topicTitle, postsCount: $0.postsCount, viewCount: $0.viewCount, createdAt: $0.createdAt))
        }
        
        responseTopics.forEach { topic in
            
            if let topicOwnerId = topic.posters?.filter({ poster -> Bool in
                poster.description.starts(with: "Original Poster")
            }).first?.userId {
                do {
                    if let data = try topicRepository.loadUserAvatarBy(userId: topicOwnerId) {
                        joinnedModelSet.insert(TopicCellModel(id: topic.id, userImage: UIImage(data: data), topicTitle: topic.title, postsCount: topic.postsCount, viewCount: topic.views ?? 0, createdAt: topic.createdAt ?? "\(Date())"))
                        
                        if (response.topicList.topics.count + currentModel.count) ==  joinnedModelSet.count {
                            let finalModel = Array(joinnedModelSet.sorted(by: { (topic1, topic2) -> Bool in
                                topic1.createdAt > topic2.createdAt
                            }))
                            view?.updateModel(model: finalModel, moreTopicsUrl: response.topicList.moreTopicsUrl)
                        }
                    } else {
                        
                        if let avatarTemplate = response.users.filter({ user -> Bool in
                            user.id == topicOwnerId
                        }).first?.avatarTemplate {
                            
                            topicRepository.downloadUserAvatar(avatarTemplate: avatarTemplate, imageSize: .topicCellSize) { [weak self] result in
                                switch result {
                                case .success(let data):
                                    
                                    do {
                                        try self?.topicRepository.updateOrSaveUserAvatarWith(userAvatarData: UserAvatarModel(userAvatar: data, userId: topicOwnerId))
                                    } catch (let error) {
                                        print("Error saving user avatar into database: \(error.localizedDescription)")
                                    }
                                    
                                    joinnedModelSet.insert(TopicCellModel(id: topic.id, userImage: UIImage(data: data), topicTitle: topic.title, postsCount: topic.postsCount, viewCount: topic.views ?? 0, createdAt: topic.createdAt ?? "\(Date())"))
                                    
                                    if (response.topicList.topics.count + currentModel.count) ==  joinnedModelSet.count {
                                        let finalModel = Array(joinnedModelSet.sorted(by: { (topic1, topic2) -> Bool in
                                            topic1.createdAt > topic2.createdAt
                                        }))
                                        self?.view?.updateModel(model: finalModel, moreTopicsUrl: response.topicList.moreTopicsUrl)
                                    }
                                    
                                case .failure(let error):
                                    self?.view?.showError(message: "Error downloading user avatar")
                                    print("Error donwloading user avatar: \(error.localizedDescription)")
                                }
                            }
                            
                        } else {
                            joinnedModelSet.insert(TopicCellModel(id: topic.id, userImage: nil, topicTitle: topic.title, postsCount: topic.postsCount, viewCount: topic.views ?? 0, createdAt: topic.createdAt ?? "\(Date())"))
                            
                            if (response.topicList.topics.count + currentModel.count) ==  joinnedModelSet.count {
                                let finalModel = Array(joinnedModelSet.sorted(by: { (topic1, topic2) -> Bool in
                                    topic1.createdAt > topic2.createdAt
                                }))
                                view?.updateModel(model: finalModel, moreTopicsUrl: response.topicList.moreTopicsUrl)
                            }
                        }
                    }
                    
                } catch (let error) {
                    print("Error loading user avatar from database: \(error.localizedDescription)")
                }
                
            }
        }
    }
    
    private func updateModel(topicListResponse: TopicListResponse) {
        var model = [TopicCellModel]()
        
        topicListResponse.topicList.topics.forEach { topic in
            let topicId = topic.id
            let topicTitle = topic.title
            let postsCount = topic.postsCount
            let viewCount = topic.views ?? 0
            let createdAt = topic.createdAt ?? "\(Date())"
            
            if let topicOwnerId = topic.posters?.filter({ poster -> Bool in
                poster.description.starts(with: "Original Poster")
            }).first?.userId {
                do {
                    if let data = try topicRepository.loadUserAvatarBy(userId: topicOwnerId) {
                        model.append(TopicCellModel(id: topicId, userImage: UIImage(data: data), topicTitle: topicTitle, postsCount: postsCount, viewCount: viewCount, createdAt: createdAt))
                        
                        if (topicListResponse.topicList.topics.count == model.count) {
                            view?.updateModel(model: model.sorted(by: { (topic1, topic2) -> Bool in
                                topic1.createdAt > topic2.createdAt
                            }), moreTopicsUrl: topicListResponse.topicList.moreTopicsUrl)
                        }
                        
                    } else {
                        
                        if let avatarTemplate = topicListResponse.users.filter({ user -> Bool in
                            user.id == topicOwnerId
                        }).first?.avatarTemplate,
                            !isNetworkConnectionNotified {
                            
                            topicRepository.downloadUserAvatar(avatarTemplate: avatarTemplate, imageSize: .topicCellSize) { [weak self] result in
                                switch result {
                                case .success(let data):
                                    
                                    do {
                                        try self?.topicRepository.updateOrSaveUserAvatarWith(userAvatarData: UserAvatarModel(userAvatar: data, userId: topicOwnerId))
                                    } catch (let error) {
                                        print("Error saving user avatar into database: \(error.localizedDescription)")
                                    }
                                    
                                    model.append(TopicCellModel(id: topicId, userImage: UIImage(data: data), topicTitle: topicTitle, postsCount: postsCount, viewCount: viewCount, createdAt: createdAt))
                                    
                                case .failure(let error):
                                    model.append(TopicCellModel(id: topicId, userImage: nil, topicTitle: topicTitle, postsCount: postsCount, viewCount: viewCount, createdAt: createdAt))
                                    
                                    if error._code == -1009 {
                                        print("Error Internet connection is not available: \(error)")
                                        
                                    }
                                    self?.view?.showError(message: "Error downloading user avatar")
                                    print("Error donwloading user avatar: \(error.localizedDescription)")
                                }
                                
                                if (topicListResponse.topicList.topics.count == model.count) {
                                    self?.view?.updateModel(model: model.sorted(by: { (topic1, topic2) -> Bool in
                                        topic1.createdAt > topic2.createdAt
                                    }), moreTopicsUrl: topicListResponse.topicList.moreTopicsUrl)
                                }
                            }
                            
                        } else {
                            model.append(TopicCellModel(id: topicId, userImage: nil, topicTitle: topicTitle, postsCount: postsCount, viewCount: viewCount, createdAt: createdAt))
                            
                            if (topicListResponse.topicList.topics.count == model.count) {
                                view?.updateModel(model: model.sorted(by: { (topic1, topic2) -> Bool in
                                    topic1.createdAt > topic2.createdAt
                                }), moreTopicsUrl: topicListResponse.topicList.moreTopicsUrl)
                            }
                        }
                    }
                    
                } catch (let error) {
                    print("Error loading user avatar from database: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func loadTopicListFromDatabase(topicFilterName: TopicFilterType) {
        switch topicFilterName {
        case .top:
            do {
                // Load top topic reponse from database and update model
                if let topTopicResponse = try topicRepository.loadTopTopicsResponse() {
                    updateModel(topicListResponse: topTopicResponse)
                }
            } catch (let e) {
                view?.showError(message: "Error loading Topics")
                print("Error loading Topics: \(e.localizedDescription)")
            }
        case .latest:
            do {
                // Load top topic reponse from database and update model
                if let latestTopicsResponse = try topicRepository.loadLatestTopicsResponse() {
                    updateModel(topicListResponse: latestTopicsResponse)
                }
            } catch (let e) {
                view?.showError(message: "Error loading Topics")
                print("Error loading Topics: \(e.localizedDescription)")
            }
        }
    }
}

extension TopicListModelView: TopicListViewControllerDelegate {
    
    func viewDidLoad(topicFilterName: TopicFilterType) {
        
        loadTopicListFromDatabase(topicFilterName: topicFilterName)
        
        pageNumber = 0
        if (NetworkReachability.isNetworkAvailable()) {
            requestTopics(topicFilter: topicFilterName, moreTopicsUrl: nil)
            isNetworkConnectionNotified = false
        } else {
            if (!isNetworkConnectionNotified) {
                view?.showError(message: "Internet connection appears to be offline. Using local data")
                print("Internet connection appears to be offline. Using local data")
                isNetworkConnectionNotified = true
            }
        }
    }
    
    func refreshTopicList(topicFilterName: TopicFilterType) {
        pageNumber = 0
        if (NetworkReachability.isNetworkAvailable()) {
            requestTopics(topicFilter: topicFilterName, moreTopicsUrl: nil)
            do {
                // TODO: - Update the existing ones and delete the rest
                try topicRepository.initTopicListDefaultData()
            } catch (let error) {
                view?.showError(message: "Error initializing TopicList data in database")
                print("Error initializing TopicList data in database: \(error.localizedDescription)")
            }
            isNetworkConnectionNotified = false
        } else {
            if (!isNetworkConnectionNotified) {
                view?.showError(message: "Internet connection appears to be offline. Using local data")
                print("Internet connection appears to be offline. Using local data")
                isNetworkConnectionNotified = true
            }
            
            loadTopicListFromDatabase(topicFilterName: topicFilterName)
            
        }
    }
    
    
    func requestTopics(topicFilter topicFiler: TopicFilterType, moreTopicsUrl: String?) {
        switch topicFiler {
        case .latest:
            topicRepository.fetchLatestTopics(order: .created, page: pageNumber) { [weak self] result in
                switch result {
                case .success(let response):
                    do {
                        try self?.topicRepository.saveTopicListResponse(topicListResponse: response)
                    } catch (let error) {
                        if error._code == -1009 {
                            print("Error Internet connection is not available: \(error)")
                            
                        }
                        self?.view?.showError(message: "Error saving TopicListResponse")
                        print("Error fetching Topics: \(error.localizedDescription)")
                    }
                    if self?.pageNumber ?? 0 > 0 {
                        guard let currentModel = self?.view?.getCurrentModel() else {
                            return
                        }
                        
                        self?.joinResponseToModel(currentModel: currentModel, response: response)
                        
                    } else {
                        self?.updateModel(topicListResponse: response)
                    }
                    
                    self?.pageNumber += 1
                case .failure(let error):
                    if error._code == -1009 {
                        print("Error Internet connection is not available: \(error)")
                        self?.view?.showError(message: "Internet connection appears to be offline. Using local data.")
                    }
                    self?.view?.showError(message: "Error fetching Topics")
                    print("Error fetching Topics: \(error.localizedDescription)")
                }
            }
        case .top:
            topicRepository.fetchTopTopics() { [weak self] result in
                switch result {
                case .success(let response):
                    do {
                        try self?.topicRepository.saveTopicListResponse(topicListResponse: response)
                    } catch (let error) {
                        if error._code == -1009 {
                            print("Error Internet connection is not available: \(error)")
                            
                        }
                        self?.view?.showError(message: "Error saving TopicListResponse")
                        print("Error fetching Topics: \(error.localizedDescription)")
                    }
                    
                    if self?.pageNumber ?? 0 > 0 {
                        guard let currentModel = self?.view?.getCurrentModel() else {
                            return
                        }
                        self?.joinResponseToModel(currentModel: currentModel, response: response)
                    } else {
                        self?.updateModel(topicListResponse: response)
                    }
                    self?.pageNumber += 1
                    
                case .failure(let error):
                    if error._code == -1009 {
                        print("Error Internet connection is not available: \(error)")
                        self?.view?.showError(message: "Internet connection appears to be offline. Using local data.")
                    }
                    self?.view?.showError(message: "Error fetching Topics")
                    print("Error fetching Topics: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchUserAvatar(avatarTemplate: String?, completion: @escaping ((Result<UIImage, Error>) -> ())) {
        if let avatarTemplate = avatarTemplate {
            topicRepository.downloadUserAvatar(avatarTemplate: avatarTemplate,  imageSize: .topicCellSize) { result in
                switch result {
                case .success(let data):
                    if let userAvatar = UIImage(data: data) {
                        completion(.success(userAvatar))
                    } else {
                        completion(.success(UIImage(named: "ahoyUserAvatarPlaceholder") ?? UIImage()))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func didSelectTopic(topicId: Int) {
        view?.navigateToPostList(topicId: topicId)
    }
    
    func topicFilterSelected(topicFilter: TopicFilterType) {
        view?.clearTableView()
        view?.updateTopicFilterName(topicFilterName: topicFilter)
        refreshTopicList(topicFilterName: topicFilter)
    }
    
    func newTopicClicked() {
        view?.navigateToNewTopic()
    }
}

// MARK: - Protocol TopicListModelViewDelegate definition
// Interaction with View
protocol TopicListModelViewDelegate:class {
    func getCurrentModel() -> [TopicCellModel]?
    func showError(message: String)
    func navigateToPostList(topicId: Int)
    func updateModel(model: [TopicCellModel], moreTopicsUrl: String?)
    func updateTopicFilterName(topicFilterName: TopicFilterType)
    func clearTableView()
    func navigateToNewTopic()
}
