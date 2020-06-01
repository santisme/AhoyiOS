//
//  LocalRepository.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 27/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

// Public class to get a repository
final class Repository {
    static let factory = LocalRepository()
}

final class LocalRepository {
    
    // MARK: - Private Properties
    lazy private var database: DatabaseCoreData = DatabaseCoreData()
    
    func deletePrivateMessagesByArchetype(archetype: TopicArchetype) throws {
        do {
            try deleteTopicsByArchetype(archetype: archetype)
        } catch {
            print("Error deleting private messages")
            throw error
        }
    }
    
    func deleteTopicsByArchetype(archetype: TopicArchetype) throws {
        do {
            try database.deleteTopicsByArchetype(archetype: archetype)
        } catch {
            print("Error deleting private messages")
            throw error
        }
    }
    
}

// MARK: - Extension SignUpRepositoryProtocol implementation
extension LocalRepository: SignUpRepositoryProtocol {
    func signUp(signUpModel: SignUpModel, completion: @escaping (Result<SignUpResponse, Error>) -> ()) {
        let apiSession = APISession()
        let signUpRepository = SignUpRepository(apiSession: apiSession)
        
        signUpRepository.signUp(signUpModel: signUpModel) {
            completion($0)
        }
    }
}

// MARK: - Extension SignInRepositoryProtocol implementation
extension LocalRepository: SignInRepositoryProtocol {
    func signIn(signInModel: SignInModel, completion: @escaping (Result<SignInResponse, Error>) -> ()) {
        let apiSession = APISession()
        let signInRepository = SignInRepository(apiSession: apiSession)
        
        signInRepository.signIn(signInModel: signInModel) {
            completion($0)
        }
    }
    
}

// MARK: - Extension PasswordRecoveryRepositoryProtocol implementation
extension LocalRepository: PasswordRecoveryRepositoryProtocol {
    func resetPassword(passwordRecoveryModel: PasswordRecoveryModel, completion: @escaping (Result<PasswordRecoveryResponse, Error>) -> ()) {
        let apiSession = APISession()
        let passwordRecoveryRepository = PasswordRecoveryRepository(apiSession: apiSession)
        
        passwordRecoveryRepository.resetPassword(passwordRecoveryModel: passwordRecoveryModel) {
            completion($0)
        }
    }
}

// MARK: - Extension DatabaseCoreDataProtocol implementation
extension LocalRepository: DatabaseCoreDataProtocol {
    // MARK: - Database Init Methods
    func initDefaultData() throws {
        do {
            try self.database.initDefaultData()
        } catch {
            print("Error initializing database default data")
            throw error
        }
    }
    
    func initDiscourseCategoryDefaultData() throws {
        do {
            try self.database.initDiscourseCategoryDefaultData()
        } catch {
            print("Error initializing database DiscourseCategory default data")
            throw error
        }
    }
    
    func initTopicListDefaultData() throws {
        do {
            try self.database.initTopicListDefaultData()
        } catch {
            print("Error initializing database TopicList default data")
            throw error
        }
    }

    // MARK: - Database Save methods
    func saveLoggedUser(user: User) throws {
        do {
            try self.database.saveUserData(userModel: user, logged: true)
        } catch let error {
            print("Error saving user logged to database: \(error.localizedDescription)")
            throw error
        }
    }
    
    func saveDiscourseCategoryList(discourseCategoryList: [DiscourseCategory]) throws {
        do {
            try self.database.saveDiscourseCategoryList(discourseCategoryList: discourseCategoryList)
        } catch {
            print("Error saving category list: \(discourseCategoryList)")
            throw error
        }
    }
    
    func savePrivateMessages(privateMessageList: [Topic]) throws {
        do {
            try self.database.savePrivateMessages(privateMessageList: privateMessageList)
        } catch {
            print("Error saving private message list: \(privateMessageList)")
            throw error
        }
    }
    
    func saveTopicListResponse(topicListResponse: TopicListResponse) throws {
        do {
            try database.saveTopicListResponse(topicListResponse: topicListResponse)
        } catch let error {
            print("Error saving TopicListResponse in database: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Database Load methods
    func loadLoggedUser() throws -> User? {
        do {
            let loggedUser = try database.loadLoggedUser()
            return loggedUser
        } catch let error {
            print("Error fetching logged user from database: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadTopTopicsResponse() throws -> TopTopicsResponse? {
        do {
            return try database.loadTopTopicsResponse()
        } catch let error {
            print("Error fetching topics from database: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadLatestTopicsResponse() throws -> TopicListResponse? {
           do {
               return try database.loadLatestTopicsResponse()
           } catch let error {
               print("Error fetching topics from database: \(error.localizedDescription)")
               throw error
           }
       }
    
    func loadPostListResponseBy(topicId: Int) throws -> SingleTopicResponse? {
        do {
            return try database.loadPostListResponseBy(topicId: topicId)
        } catch let error {
            print("Error fetching posts from database: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadDiscourseCategoryListResponse() throws -> DiscourseCategoryListResponse? {
        do {
            return try database.loadDiscourseCategoryListResponse()
        } catch let error {
            print("Error fetching discourse categories from database: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadUserAvatarBy(userId: Int) throws -> Data? {
        do {
            return try database.loadUserAvatarBy(userId: userId)
        } catch let error {
            print("Error fetching User Avatar from database: \(error.localizedDescription)")
            throw error
        }
    }

    func loadUserBy(username: String) throws -> User? {
        do {
            return try database.loadUserBy(username: username)
        } catch let error {
            print("Error fetching User from database: \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Database Update methods
    func logOutUserById(id: Int) throws {
        do {
            try self.database.logOutUserById(id: id)
        } catch let error {
            print("Error updating logged user in database: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateOrSaveTopicWith(topicData: Topic) throws {
        do {
            try database.updateOrSaveTopicWith(topicData: topicData)
        } catch let error {
            print("Error updating topic in database: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateOrSaveUserWith(userData: User) throws {
        do {
            try database.updateOrSaveUserWith(userData: userData)
        } catch let error {
            print("Error updating user in database: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateOrSavePostListResponseWith(postListResponse: SingleTopicResponse) throws {
        do {
            try database.updateOrSavePostListResponseWith(postListResponse: postListResponse)
        } catch let error {
            print("Error updating user in database: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateOrSaveUserAvatarWith(userAvatarData: UserAvatarModel) throws {
        do {
            try database.updateOrSaveUserAvatarWith(userAvatarData: userAvatarData)
        } catch let error {
            print("Error updating user avatar in database: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Database Delete methods
    func deleteUserBy(id: Int) throws {
        do {
            try self.database.deleteUserBy(id: id)
        } catch let error {
            print("Error deleting user with id: \(id) from database: \(error.localizedDescription)")
            throw error
        }
    }

}

extension LocalRepository: UserDetailRepositoryProtocol {
    func downloadUserAvatar(avatarTemplate: String,  imageSize: UserAvatarSize, completion: @escaping (Result<Data, Error>) -> ()) {
        let apiSession = APISession()
        let userDetailRepository = UserDetailRepository(apiSession: apiSession)
        
        userDetailRepository.downloadUserAvatar(avatarTemplate: avatarTemplate,  imageSize: imageSize) {
            completion($0)
        }
    }
    
}

extension LocalRepository: DiscourseCategoryRepositoryProtocol {
    func fetchDiscourseCategoryList(completion: @escaping (Result<DiscourseCategoryListResponse, Error>) -> ()) {
        let apiSession = APISession()
        let discourseCategoryRepository = DiscourseCategoryRepository(apiSession: apiSession)
        
        discourseCategoryRepository.fetchDiscourseCategoryList {
            completion($0)
        }
    }
    
}

extension LocalRepository: TopicRepositoryProtocol {

    func fetchLatestTopics(order: TopicsOrder? = .byDefault, ascending: Bool? = false, page: Int? = 1, completion: @escaping (Result<LatestTopicsResponse, Error>) -> ()) {
        let apiSession = APISession()
        let topicRepository = TopicRepository(apiSession: apiSession)
        
        topicRepository.fetchLatestTopics(order: order, ascending: ascending, page: page) {
            completion($0)
        }
    }
    
    func fetchTopTopics(completion: @escaping (Result<LatestTopicsResponse, Error>) -> ()) {
        let apiSession = APISession()
        let topicRepository = TopicRepository(apiSession: apiSession)
        
        topicRepository.fetchTopTopics() {
            completion($0)
        }
    }
    
    func createNewTopic(title: String, raw: String, categoryId: Int?, createdAt: String, completion: @escaping (Result<NewTopicResponse, Error>) -> ()) {
        let apiSession = APISession()
        let topicRepository = TopicRepository(apiSession: apiSession)
        
        topicRepository.createNewTopic(title: title, raw: raw, categoryId: categoryId, createdAt: createdAt) {
            completion($0)
        }
    }
    
}

extension LocalRepository: PrivateMessagesRepositoryProtocol {
    func fetchPrivateMessagesByUserId(username: String, completion: @escaping (Result<PrivateMessagesByUserResponse, Error>) -> ()) {
        let apiSession = APISession()
        let privateMessageRepository = PrivateMessagesRepository(apiSession: apiSession)
        
        privateMessageRepository.fetchPrivateMessagesByUserId(username: username) {
            completion($0)
        }
    }
    
}

extension LocalRepository: PostRepositoryProtocol {

    func fetchSingleTopic(topicId: Int, completion: @escaping (Result<SingleTopicResponse, Error>) -> ()) {
        let apiSession = APISession()
        let postRespository = PostRepository(apiSession: apiSession)
        
        postRespository.fetchSingleTopic(topicId: topicId) {
            completion($0)
        }
    }
    
    func createNewPost(topicId: Int, raw: String, createdAt: String, completion: @escaping (Result<NewPostResponse, Error>) -> ()) {
        let apiSession = APISession()
        let postRepository = PostRepository(apiSession: apiSession)
        
        postRepository.createNewPost(topicId: topicId, raw: raw, createdAt: createdAt) {
            // TODO: - Update insert post in database
//            self?.database.updateSingleTopic(topicId: topicId, apiSession: apiSession) { _ in return }
            completion($0)
        }
    }
    
}

extension LocalRepository: SearchRepositoryProtocol {
    func searchTerm(term: String, completion: @escaping (Result<SearchResponse, Error>) -> ()) {
        let apiSession = APISession()
        let searchRepository = SearchRepository(apiSession: apiSession)
        
        searchRepository.searchTerm(term: term) {
            completion($0)
        }
    }
}

// MARK: Protocol LocalRepositoryDatabaseDelegate
protocol LocalRepositoryDatabaseDelegate {
    func initDefaultData() throws
    func initDefaultUserData() throws
    func initTopicListDefaultData() throws
    func deleteAllData(entity: DatabaseEntities) throws
    func deleteUserBy(id: Int) throws
    func saveUserData(userModel: User, logged: Bool?) throws
    func saveDiscourseCategoryList(discourseCategoryList: [DiscourseCategory]) throws
    func savePrivateMessages(privateMessageList: [Topic]) throws
    func saveTopicListResponse(topicListResponse: TopicListResponse) throws
    func deleteTopicsByArchetype(archetype: TopicArchetype) throws
    func updateOrSaveTopicWith(topicData: Topic) throws
    func updateOrSaveUserWith(userData: User) throws
    func updateOrSavePostListResponseWith(postListResponse: SingleTopicResponse) throws
    func updateOrSaveUserAvatarWith(userAvatarData: UserAvatarModel) throws
    func loadTopTopicsResponse() throws -> TopicListResponse?
    func loadLatestTopicsResponse() throws -> TopicListResponse?
    func loadPostListResponseBy(topicId: Int) throws -> SingleTopicResponse?
    func loadDiscourseCategoryListResponse() throws -> DiscourseCategoryListResponse?
    func loadUserAvatarBy(userId: Int) throws -> Data?
    func loadUserBy(username: String) throws -> User?
}
