//
//  TopicSearchModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 24/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

enum SearchScopeItem: String {
    case topics
    case posts
}

final class TopicSearchModelView {
    // MARK: - Private Properties
    weak private var view: TopicSearchModelViewDelegate?
    private let searchRepository: LocalRepository
    private let topicsPerPage: Int = 30
    private var pageNumber: Int = 0
    private var topicCellModel = [TopicCellModel]()
    private var postCellModelWrapper = [PostCellModelWrapper]()
    private var searchResponse: SearchResponse? = nil
    private var isNetworkConnectionNotified = false

    private let searchScopeItems: [SearchScopeItem] = [.topics, .posts]
    private var currentScopeItem: SearchScopeItem = .topics
    
    // MARK: - Inits
    init(view: TopicSearchModelViewDelegate? = nil, searchRepository: LocalRepository) {
        self.view = view
        self.searchRepository = searchRepository
    }
    
    // MARK: - Private Methods
    private func updateTopicCellModel(topicList: [Topic]) {
        topicCellModel.removeAll()
        topicList.forEach { topic in
            topicCellModel.append(TopicCellModel(id: topic.id, userImage: nil, topicTitle: topic.title, postsCount: topic.postsCount, viewCount: topic.views ?? 0, createdAt: topic.createdAt ?? ""))
        }
        updateModelBySelectedScope()

    }
    
    private func updatePostCellModel(postList: [Post]) {
        postCellModelWrapper.removeAll()
        postList.forEach { post in
            postCellModelWrapper.append(PostCellModelWrapper(postCellModel: PostCellModel(userImage: nil, username: post.username, postContent: post.blurb ?? "", updatedAt: post.updatedAt ?? ""), topicId: post.topicId))
        }
        updateModelBySelectedScope()

    }
    
    private func updateModelBySelectedScope() {
        switch currentScopeItem {
        case .topics:
            view?.updateTopicCellModel(topicCellModel: topicCellModel)
        case .posts:
            view?.updatePostCellModelWrapper(postCellModelWrapper: postCellModelWrapper)
        }
    }
    

    
//    private func updateModel(topicListResponse: TopicListResponse) {
//        var model = [TopicCellModel]()
//
//        topicListResponse.topicList.topics.forEach { topic in
//            let topicId = topic.id
//            let topicTitle = topic.title
//            let postsCount = topic.postsCount
//            let viewCount = topic.views ?? 0
//            let createdAt = topic.createdAt ?? "\(Date())"
//
//            if let topicOwnerId = topic.posters?.filter({ poster -> Bool in
//                poster.description.starts(with: "Original Poster")
//            }).first?.userId {
//                do {
//                    if let data = try searchRepository.loadUserAvatarBy(userId: topicOwnerId) {
//                        model.append(TopicCellModel(id: topicId, userImage: UIImage(data: data), topicTitle: topicTitle, postsCount: postsCount, viewCount: viewCount, createdAt: createdAt))
//
//                        if (topicListResponse.topicList.topics.count == model.count) {
//                            view?.updateModel(model: model.sorted(by: { (topic1, topic2) -> Bool in
//                                topic1.createdAt > topic2.createdAt
//                            }), moreTopicsUrl: topicListResponse.topicList.moreTopicsUrl)
//                        }
//
//                    } else {
//
//                        if let avatarTemplate = topicListResponse.users.filter({ user -> Bool in
//                            user.id == topicOwnerId
//                        }).first?.avatarTemplate,
//                            !isNetworkConnectionNotified {
//
//                            searchRepository.downloadUserAvatar(avatarTemplate: avatarTemplate, imageSize: .topicCellSize) { [weak self] result in
//                                switch result {
//                                case .success(let data):
//
//                                    do {
//                                        try self?.searchRepository.updateOrSaveUserAvatarWith(userAvatarData: UserAvatarModel(userAvatar: data, userId: topicOwnerId))
//                                    } catch (let error) {
//                                        print("Error saving user avatar into database: \(error.localizedDescription)")
//                                    }
//
//                                    model.append(TopicCellModel(id: topicId, userImage: UIImage(data: data), topicTitle: topicTitle, postsCount: postsCount, viewCount: viewCount, createdAt: createdAt))
//
//                                case .failure(let error):
//                                    model.append(TopicCellModel(id: topicId, userImage: nil, topicTitle: topicTitle, postsCount: postsCount, viewCount: viewCount, createdAt: createdAt))
//
//                                    if error._code == -1009 {
//                                        print("Error Internet connection is not available: \(error)")
//
//                                    }
//                                    self?.view?.showError(message: "Error downloading user avatar")
//                                    print("Error donwloading user avatar: \(error.localizedDescription)")
//                                }
//
//                                if (topicListResponse.topicList.topics.count == model.count) {
//                                    self?.view?.updateModel(model: model.sorted(by: { (topic1, topic2) -> Bool in
//                                        topic1.createdAt > topic2.createdAt
//                                    }), moreTopicsUrl: topicListResponse.topicList.moreTopicsUrl)
//                                }
//                            }
//
//                        } else {
//                            model.append(TopicCellModel(id: topicId, userImage: nil, topicTitle: topicTitle, postsCount: postsCount, viewCount: viewCount, createdAt: createdAt))
//
//                            if (topicListResponse.topicList.topics.count == model.count) {
//                                view?.updateModel(model: model.sorted(by: { (topic1, topic2) -> Bool in
//                                    topic1.createdAt > topic2.createdAt
//                                }), moreTopicsUrl: topicListResponse.topicList.moreTopicsUrl)
//                            }
//                        }
//                    }
//
//                } catch (let error) {
//                    print("Error loading user avatar from database: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//
//    private func loadTopicListFromDatabase(topicFilterName: TopicFilterType) {
//        switch topicFilterName {
//        case .top:
//            do {
//                // Load top topic reponse from database and update model
//                if let topTopicResponse = try searchRepository.loadTopTopicsResponse() {
//                    updateModel(topicListResponse: topTopicResponse)
//                }
//            } catch (let e) {
//                view?.showError(message: "Error loading Topics")
//                print("Error loading Topics: \(e.localizedDescription)")
//            }
//        case .latest:
//            do {
//                // Load top topic reponse from database and update model
//                if let latestTopicsResponse = try searchRepository.loadLatestTopicsResponse() {
//                    updateModel(topicListResponse: latestTopicsResponse)
//                }
//            } catch (let e) {
//                view?.showError(message: "Error loading Topics")
//                print("Error loading Topics: \(e.localizedDescription)")
//            }
//        }
//    }
}

extension TopicSearchModelView: TopicSearchViewControllerDelegate {

    func viewDidLoad() {
        view?.setScopeButtonTitles(searchScopeItems: searchScopeItems.compactMap { $0.rawValue })
    }
    
    func selectedScopeButtonIndexDidChange(selectedScope: Int) {
        currentScopeItem = searchScopeItems[selectedScope]
        view?.updateSelectedScopeItem(scopeItem: currentScopeItem)
        
        if searchResponse != nil {
            updateModelBySelectedScope()
        }
    }

    func searchBarSearchButtonClicked(searchText: String) {
        if searchText.isEmpty {
            topicCellModel.removeAll()
            postCellModelWrapper.removeAll()
            searchResponse = nil
            updateModelBySelectedScope()
        } else {
            searchRepository.searchTerm(term: searchText) { [weak self] result in
                switch result {
                case .success(let value):
                    self?.searchResponse = value
                    if let topicList = value.topics {
                        self?.updateTopicCellModel(topicList: topicList)
                    }
                    self?.updatePostCellModel(postList: value.posts)
                case .failure(let error):
                    self?.view?.showError(message: "Error fetching search")
                    print("Error fetching remote search: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        switch currentScopeItem {
        case .topics:
            view?.navigateToPostList(topicId: topicCellModel[indexPath.row].id)
        case .posts:
            view?.navigateToPostList(topicId: postCellModelWrapper[indexPath.row].topicId)
        }
    }
}

// MARK: - Protocol TopicSearchModelViewDelegate definition
// Interaction with View
protocol TopicSearchModelViewDelegate:class {
    func setScopeButtonTitles(searchScopeItems: [String])
    func updateSelectedScopeItem(scopeItem: SearchScopeItem)
    func updateTopicCellModel(topicCellModel: [TopicCellModel])
    func updatePostCellModelWrapper(postCellModelWrapper: [PostCellModelWrapper])

    func showError(message: String)
    func navigateToPostList(topicId: Int)
}
