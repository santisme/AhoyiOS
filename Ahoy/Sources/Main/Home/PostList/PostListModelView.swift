//
//  PostListModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 15/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class PostListModelView {
    
    // MARK: - Private Properties
    weak private var view: PostListModelViewProtocol?
    private let postRepository: LocalRepository
    private let topicId: Int
    
    // MARK: - Inits
    init(view: PostListModelViewProtocol? = nil, postRepository: LocalRepository, topicId: Int) {
        self.view = view
        self.postRepository = postRepository
        self.topicId = topicId
    }
    
    private func updateModel(postListResponse: SingleTopicResponse) {
        var model = [PostCellModel]()
        
        if let postsList = postListResponse.postStream?.posts.sorted(by: { (p1, p2) -> Bool in
            if let p1UpdatedAt = p1.updatedAt, let p2UpdatedAt = p2.updatedAt {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                let date1: Double = dateFormatter.date(from: p1UpdatedAt)?.timeIntervalSince1970 ?? 0
                let date2: Double = dateFormatter.date(from: p2UpdatedAt)?.timeIntervalSince1970 ?? 0
                return date1 < date2
            }
            return p1.id < p2.id
        }) {
            
            postsList.forEach { post in
                let username = post.username
                let postContent = post.cooked
                let updatedAt = post.updatedAt
                
                do {
                    
                    if let user = try postRepository.loadUserBy(username: post.username),  let data = try postRepository.loadUserAvatarBy(userId: user.id) {
                        
                        model.append(PostCellModel(userImage: UIImage(data: data) , username: username, postContent: postContent ?? "", updatedAt: updatedAt ?? ""))
                        
                        if (postsList.count == model.count) {
                            view?.updateModel(model: model)
                        }
                        
                    } else {
                        
                        if NetworkReachability.isNetworkAvailable() {
                            postRepository.downloadUserAvatar(avatarTemplate: post.avatarTemplate, imageSize: .topicCellSize) { [weak self] result in
                                switch result {
                                case .success(let data):
                                    model.append(PostCellModel(userImage: UIImage(data: data) , username: username, postContent: postContent ?? "", updatedAt: updatedAt ?? ""))
                                    
                                    if (postsList.count == model.count) {
                                        self?.view?.updateModel(model: model)
                                    }
                                    
                                case .failure(let error):
                                    self?.view?.showError(message: "Error downloading user avatar")
                                    print("Error donwloading user avatar: \(error.localizedDescription)")
                                }
                                
                            }
                            
                        } else {
                            model.append(PostCellModel(userImage: nil , username: username, postContent: postContent ?? "", updatedAt: updatedAt ?? ""))
                            
                            if (postsList.count == model.count) {
                                view?.updateModel(model: model)
                            }
                            
                        }
                    }
                } catch (let error) {
                    print("Error loading user avatar from database: \(error.localizedDescription)")
                    
                }
            }
            
        }
        
    }
    
    private func updateHeaderModel(postListResponse: SingleTopicResponse) {
        var posterList = Set<PostListPosterCellModel>()
        
        if let postsList = postListResponse.postStream?.posts {
            
            postsList.forEach { post in
                
                do {
                    
                    if let user = try postRepository.loadUserBy(username: post.username),  let data = try postRepository.loadUserAvatarBy(userId: user.id) {
                        posterList.insert(PostListPosterCellModel(userAvatar: UIImage(data: data), username: post.username))
                        
                        if (post.id == postsList.last?.id) {
                            let headerModel = PostListHeaderCellModel(topicTitle: postListResponse.title, postsCount: postsList.count, viewCount: postListResponse.views, updatedAt: postsList.last?.updatedAt ?? "", topicText: postsList.first?.cooked ?? "", posterList: Array(posterList).sorted(by: { (p1, p2) -> Bool in
                                p1.username > p2.username
                            }))
                            view?.updateHeaderModel(headerModel: headerModel)
                        }
                        
                    } else {
                        postRepository.downloadUserAvatar(avatarTemplate: post.avatarTemplate, imageSize: .topicCellSize) { [weak self] result in
                            switch result {
                            case .success(let data):
                                posterList.insert(PostListPosterCellModel(userAvatar: UIImage(data: data), username: post.username))
                                
                                if (post.id == postsList.last?.id) {
                                    let headerModel = PostListHeaderCellModel(topicTitle: postListResponse.title, postsCount: postsList.count, viewCount: postListResponse.views, updatedAt: postsList.last?.updatedAt ?? "", topicText: postsList.first?.cooked ?? "", posterList: Array(posterList).sorted(by: { (p1, p2) -> Bool in
                                        p1.username > p2.username
                                    }))
                                    self?.view?.updateHeaderModel(headerModel: headerModel)
                                }
                                
                            case .failure(let error):
                                self?.view?.showError(message: "Error downloading user avatar")
                                print("Error donwloading user avatar: \(error.localizedDescription)")
                            }
                            
                        }
                    }
                    
                } catch (let error) {
                    print("Error loading user avatar from database: \(error.localizedDescription)")
                    
                }
            }
            
        }
    }
    
    
    private func setPostFontAttributes(attributedString: NSMutableAttributedString) {
        // Font types
        let regularFont = AhoyUIResources.factory.font(style: .caption14light)
        let boldFont = AhoyUIResources.factory.font(style: )
        let italicFont = UIFont.italicSystemFont(ofSize: 14)
        
        // Check the font type of each character
        attributedString.enumerateAttribute(.font, in: NSRange(0..<attributedString.length)) { value, range, stop in
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor : AhoyUIResources.factory.color(usage: Color.ahoyMainTextColor)], range: range)
            
            if let font = value as? UIFont {
                
                // check if input font is bold
                if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    // Set bold font
                    attributedString.addAttribute(.font, value: boldFont, range: range)
                    
                    // check if input font is italic
                } else if font.fontDescriptor.symbolicTraits.contains(.traitItalic) {
                    // Set italic font
                    attributedString.addAttribute(.font, value: italicFont, range: range)
                } else {
                    // Set Regular font for the rest of cases
                    attributedString.addAttribute(.font, value: regularFont, range: range)
                }
            }
        }
        
    }
}

// MARK: - Protocol PostListViewControllerDelegate implementation
extension PostListModelView: PostListViewControllerDelegate {
    
    func viewDidLoad() {
        do {
            // Load top topic reponse from database and update model
            if let postListResponse = try postRepository.loadPostListResponseBy(topicId: topicId) {
                updateModel(postListResponse: postListResponse)
                updateHeaderModel(postListResponse: postListResponse)
            }
        } catch (let e) {
            view?.showError(message: "Error loading posts list")
            print("Error loading posts list: \(e.localizedDescription)")
        }
        
        if (NetworkReachability.isNetworkAvailable()) {
            requestPostList()
        }
        
    }
    
    func refreshPostList() {
        if (NetworkReachability.isNetworkAvailable()) {
            requestPostList()
        } else {
            do {
                // Load top topic reponse from database and update model
                if let postListResponse = try postRepository.loadPostListResponseBy(topicId: topicId) {
                    updateModel(postListResponse: postListResponse)
                    updateHeaderModel(postListResponse: postListResponse)
                }
            } catch (let e) {
                view?.showError(message: "Error loading posts list")
                print("Error loading posts list: \(e.localizedDescription)")
            }
            
        }
    }
    
    func requestPostList() {
        postRepository.fetchSingleTopic(topicId: topicId) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    try self?.postRepository.updateOrSavePostListResponseWith(postListResponse: response)
                    self?.updateModel(postListResponse: response)
                    self?.updateHeaderModel(postListResponse: response)
                } catch (let error) {
                    self?.view?.showError(message: "Error saving PostListResponse")
                    print("Error fetching PossList: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                self?.view?.showError(message: "Error fetching PostsList")
                print("Error fetching PostList: \(error.localizedDescription)")
                
            }
            
        }
        
    }
    
    func htmlToAttributedText(html: String) -> NSAttributedString? {
        do {
            if let data = html.data(using: .utf8) {
                
                let attribString = try NSMutableAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                setPostFontAttributes(attributedString: attribString)
                return attribString
            }
        } catch (let error) {
            view?.showError(message: "Error parsing html")
            print("Error parsing html: \(error.localizedDescription)")
        }
        return nil
    }
    
}

extension PostListModelView: PostListHeaderCellDelegate {
    func answerClicked() {
        view?.navigateToNewPost()
    }
    
}

protocol PostListModelViewProtocol: class {
    func updateModel(model: [PostCellModel])
    func showError(message: String)
    func updateHeaderModel(headerModel: PostListHeaderCellModel)
    func navigateToNewPost()
}
