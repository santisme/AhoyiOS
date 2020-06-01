//
//  DatabaseCoreData.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 04/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit
import CoreData

final class DatabaseCoreData {
    // MARK: - Private Methods
    // Create CoreData Context
    private func provideObjectContext() -> NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        appDelegate.persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return appDelegate.persistentContainer.viewContext
    }
    
    // Autoincrement
    private func autoincrementID(entityName: String, entityKeyId: String) -> Int? {
        guard let context = provideObjectContext() else {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: entityKeyId, ascending: false)]
        
        do {
            guard let data = try context.fetch(fetchRequest) as? [NSManagedObject],
                let maxId = data.first?.value(forKey: entityKeyId) as? Int else {
                    return 0
            }
            
            return maxId + 1
        } catch {
            print("Error al generar autoincrement id")
            return 0
        }
    }

    private func fetchDataRequestUsingType<T: NSManagedObject>(_ entity: T.Type, predicate: String? = nil) throws -> [T]? {
                
        guard let context = provideObjectContext()
//            let entityName = moSubclass.entity.name
            else {
            return nil
        }
        // Create the request to the entity
        let fetchRequest = T.fetchRequest()

        // Filter tasks by id using predicate
        if let predicateRequest = predicate, !predicateRequest.isEmpty {
            fetchRequest.predicate = NSPredicate(format: predicateRequest)
        }
        
        do {
            // Get data from database
            return try context.fetch(fetchRequest) as? [T]
            
        } catch {
            print("Error fetching NSManagedObjects for entity: \(entity)")
            return nil
        }
    }

    private func fetchDataRequest(entity: String, predicate: String? = nil) throws -> [NSManagedObject]? {
        
        guard let context = provideObjectContext() else {
            return nil
        }
        // Create the request to the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // Filter tasks by id using predicate
        if let predicateRequest = predicate, !predicateRequest.isEmpty {
            fetchRequest.predicate = NSPredicate(format: predicateRequest)
        }
        
        do {
            // Get data from database
            return try context.fetch(fetchRequest) as? [NSManagedObject]
            
        } catch {
            print("Error fetching NSManagedObjects for entity: \(entity)")
            return nil
        }
    }
    
    private func deleteData(data: [NSManagedObject]) throws {
        guard let context = provideObjectContext() else {
            return
        }

        do {
            // Delete all entries
            data.forEach { context.delete($0) }
            
            try commit(message: "Error deleting Managed Objects: \(data)")
        } catch {
            throw error
        }
    }
    
    private func commit(message: String?) throws{
        guard let context = provideObjectContext() else {
            return
        }
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error {
            print(message ?? "")
            throw error
        }
    }
    
    private func addPostsDataToPostStreamCD(posts: [Post], postStreamCD: PostStreamCD) {
        guard let context = provideObjectContext(),
            let postEntity = NSEntityDescription.entity(forEntityName: DatabaseEntities.PostCD.rawValue,
                                                        in: context)
            else {
                return
        }
        
        // Get an NSMutableSet to relate and store every Post
        let postsCD = postStreamCD.mutableSetValue(forKeyPath: "posts")
        
        // Create and add to postStreamCD every post like postCD
        posts.forEach { post in
            let postCD = PostCD(entity: postEntity, insertInto: context)
            postCD.setValue(post.id, forKey: PostCDAttr.id.rawValue)
            postCD.setValue(post.name, forKey: PostCDAttr.name.rawValue)
            postCD.setValue(post.username, forKey: PostCDAttr.username.rawValue )
            postCD.setValue(post.avatarTemplate, forKey: PostCDAttr.avatarTemplate.rawValue)
            postCD.setValue(post.cooked, forKey: PostCDAttr.cooked.rawValue)
            postCD.setValue(post.updatedAt, forKey: PostCDAttr.updatedAt.rawValue)
            postCD.setValue(post.createdAt, forKey: PostCDAttr.createdAt.rawValue)
            postCD.setValue(post.raw, forKey: PostCDAttr.raw.rawValue)
            postCD.setValue(post.topicId, forKey: PostCDAttr.topicId.rawValue)
            postsCD.add(postCD)
            
        }
        
    }
    
    private func addTopicDetailDataToTopicDetailsCD(topicDetails: TopicDetails, topicDetailsCD: TopicDetailsCD) {
        guard let context = provideObjectContext(),
            let createdByEntity = NSEntityDescription.entity(forEntityName: DatabaseEntities.CreatedByCD.rawValue,
                                                             in: context)
            else {
                return
        }
        
        let createdByCD = CreatedByCD(entity: createdByEntity, insertInto: context)
        createdByCD.setValue(topicDetails.topicCreatedBy.id, forKey: CreatedByCDAttr.id.rawValue)
        createdByCD.setValue(topicDetails.topicCreatedBy.username, forKey: CreatedByCDAttr.username.rawValue)
        topicDetailsCD.setValue(createdByCD, forKeyPath: TopicDetailsCDAttr.createdBy.rawValue)
        
    }
    
    private func addPostersDataToTopicCD(posters: [Poster], topicCD: TopicCD) throws {
        guard let context = provideObjectContext(),
            let entity = NSEntityDescription.entity(forEntityName: DatabaseEntities.PosterCD.rawValue, in: context) else {
                return
        }
        
        let postersCD = topicCD.mutableSetValue(forKey: TopicCDAttr.posters.rawValue)
        do {
            try posters.forEach { poster in
                if let userId = poster.userId {
                    guard let userCD = try loadUserCDById(id: userId)
                        else { return }
                    let posterCD = PosterCD(entity: entity, insertInto: context)
                    posterCD.setValue(userCD, forKeyPath: PosterCDAttr.userId.rawValue)
                    posterCD.setValue(poster.description, forKey: PosterCDAttr.posterDescription.rawValue)
                    postersCD.add(posterCD)
                }
            }
            
        } catch (let error) {
            print("Error saving posters: \(posters)")
            throw error
        }

    }
    
    private func TopicDataToCD(data: Topic) throws -> TopicCD? {
        guard let context = provideObjectContext(),
            let singleTopicEntity = NSEntityDescription.entity(forEntityName: DatabaseEntities.TopicCD.rawValue,
                                                               in: context),
            let postStreamEntity = NSEntityDescription.entity(forEntityName: DatabaseEntities.PostStreamCD.rawValue,
                                                              in: context),
            let topicDetailsEntity = NSEntityDescription.entity(forEntityName: DatabaseEntities.TopicDetailsCD.rawValue, in: context)
            else {
                return nil
        }
        
        let topicCD = TopicCD(entity: singleTopicEntity, insertInto: context)

        if let posts: [Post] = data.postStream?.posts {
            let postStreamCD = PostStreamCD(entity: postStreamEntity, insertInto: context)
            addPostsDataToPostStreamCD(posts: posts, postStreamCD: postStreamCD)
            topicCD.setValue(postStreamCD, forKeyPath: TopicCDAttr.postStream.rawValue)
            
        }

        if let topicDetails = data.topicDetails {
            let topicDetailsCD = TopicDetailsCD(entity: topicDetailsEntity, insertInto: context)
            addTopicDetailDataToTopicDetailsCD(topicDetails: topicDetails , topicDetailsCD: topicDetailsCD)
            topicCD.setValue(topicDetailsCD, forKeyPath: TopicCDAttr.topicDetails.rawValue)
        }

        if let bumped: Bool = data.bumped {
            topicCD.setValue(bumped, forKey: TopicCDAttr.bumped.rawValue)
            
        }
        
        topicCD.setValue(data.id, forKey: TopicCDAttr.id.rawValue)
        topicCD.setValue(data.title, forKey: TopicCDAttr.title.rawValue)
        topicCD.setValue(data.categoryId, forKey: TopicCDAttr.categoryId.rawValue)
        topicCD.setValue(data.archetype, forKey: TopicCDAttr.archetype.rawValue)
        topicCD.setValue(data.createdAt, forKey: TopicCDAttr.createdAt.rawValue)

        do {
            if let posters = data.posters {
                try addPostersDataToTopicCD(posters: posters, topicCD: topicCD)
            }
        } catch (let error) {
            print("Error parsing topic data to CD: \(data)")
            throw error
        }
        return topicCD
        
    }

    
    private func TopicCDtoData(topicCD: TopicCD) -> Topic {
        let id = topicCD.id
        let title = topicCD.title
        let postsCount = topicCD.postsCount
        let views = topicCD.views
        let categoryId = topicCD.categoryId
        let archetype = topicCD.archetype
        let createdAt = topicCD.createdAt
        let bumped = topicCD.bumped
        
        var topicDetails: TopicDetails? = nil
        if let createdByCD = topicCD.topicDetails?.createdBy?.user {
            topicDetails = TopicDetails(topicCreatedBy: User(id: Int(createdByCD.id), username: createdByCD.username, name: createdByCD.name, avatarTemplate: createdByCD.avatarTemplate, lastSeenAt: createdByCD.lastSeenAt, moderator: createdByCD.moderator))
        }
        
        // Get Posters data
        let postersCD = topicCD.mutableSetValue(forKeyPath: TopicCDAttr.posters.rawValue)
        var posters = [Poster]()
        postersCD.forEach { posterData in
            guard let posterCD = posterData as? PosterCD,
                let posterDescription = posterCD.posterDescription,
                let userCD = posterCD.userId
                else { return }
            posters.append(Poster(description: posterDescription, userId: Int(userCD.id)))
            
        }
        
        let postStreamCD = topicCD.postStream
        if let postsCD = postStreamCD?.posts {
            let posts: [Post] = postsCD.compactMap { post in
                guard let postCD = post as? PostCD else {
                    return nil
                }
                let id = Int(postCD.id)
                let name = postCD.name
                let username = postCD.username
                let cooked = postCD.cooked
                let blurb = postCD.blurb
                let raw = postCD.raw
                let avatarTemplate = postCD.avatarTemplate
                let updatedAt = postCD.updatedAt
                let createdAt = postCD.createdAt
                let topicId = Int(postCD.topicId)
                
                return Post(id: id, name: name, username: username ?? "", avatarTemplate: avatarTemplate ?? "", cooked: cooked ?? "", blurb: blurb ?? "", raw: raw ?? "", updatedAt: updatedAt ?? "", createdAt: createdAt ?? "", topicId: topicId)
                
            }.sorted(by: { (p1, p2) -> Bool in
                if let p1UpdatedAt = p1.updatedAt, let p2UpdatedAt = p2.updatedAt {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    let date1: Double = dateFormatter.date(from: p1UpdatedAt)?.timeIntervalSince1970 ?? 0
                    let date2: Double = dateFormatter.date(from: p2UpdatedAt)?.timeIntervalSince1970 ?? 0
                    return date1 < date2
                }
                
                return p1.id < p2.id
            })
            
            return Topic(id: Int(id), title: title ?? "", postsCount: Int(postsCount), views: Int(views), categoryId: Int(categoryId), posters: posters, createdAt: createdAt, archetype: archetype, postStream: PostStream(posts: posts), topicDetails: topicDetails, bumped: bumped)

        } else {
            return Topic(id: Int(id), title: title ?? "", postsCount: Int(postsCount), views: Int(views), categoryId: Int(categoryId), posters: posters, createdAt: createdAt, archetype: archetype, postStream: nil, topicDetails: topicDetails, bumped: bumped)
        }
    }

    
    private func userCDToData(userCD: UserCD) -> User {
        return User(id: Int(userCD.id), username: userCD.username, name: userCD.name, avatarTemplate: userCD.avatarTemplate, lastSeenAt: userCD.lastSeenAt, moderator: userCD.moderator)
    }
    
    private func discourseCategoryCDtoData(discourseCategoryCD: DiscourseCategoryCD) -> DiscourseCategory {
        let id = Int(discourseCategoryCD.id)
        let name = discourseCategoryCD.name
        let color = discourseCategoryCD.color
        let textColor = discourseCategoryCD.textColor
        return DiscourseCategory(id: id, name: name ?? "", color: color ?? "", textColor: textColor ?? "")
    }
    
    
    private func loadUserAvatarCDBy(userId: Int) throws -> UserAvatarCD? {
        do {
            // Get data from database
            guard let data = try self.fetchDataRequestUsingType(UserAvatarCD.self,
                                                                predicate: "\(UserAvatarCDAttr.userId.rawValue) = \(userId)")
                else {
                    return nil
            }
            return data.first
        } catch {
            print("Error fetching UserCD data: \(error.localizedDescription)")
            throw error
        }
    }
}

// MARK: - Extension LocalRepositoryDatabaseDelegate implementation
extension DatabaseCoreData: LocalRepositoryDatabaseDelegate {
    
    // MARK: - InitDefaultData Methods
    func initDefaultData() throws {
        do {
            try DatabaseEntities.allCases.forEach {
                try deleteAllData(entity: $0)
            }
            
        } catch {
            throw error
        }
    }
    
    func initDefaultUserData() throws {
        do {
            try deleteAllData(entity: DatabaseEntities.UserCD)
        } catch {
            throw error
        }
    }
    
    func initDiscourseCategoryDefaultData() throws {
        do {
            try deleteAllData(entity: DatabaseEntities.DiscourseCategoryCD)
        } catch {
            throw error
        }
    }
    
    func initTopicListDefaultData() throws {
        do {
            try deleteAllData(entity: DatabaseEntities.TopicCD)
        } catch {
            throw error
        }
    }
    
    // MARK: - Save Methods
    func saveUserData(userModel: User, logged: Bool? = false) throws {
        guard let context = provideObjectContext(),
        let userEntity = NSEntityDescription.entity(forEntityName: DatabaseEntities.UserCD.rawValue, in: context)
            else {
                return
        }
        
        let userCD = UserCD(entity: userEntity, insertInto: context)
        userCD.setValue(userModel.id, forKey: UserCDAttr.id.rawValue)
        userCD.setValue(userModel.name, forKey: UserCDAttr.name.rawValue)
        userCD.setValue(userModel.username, forKey: UserCDAttr.username.rawValue)
        userCD.setValue(userModel.avatarTemplate, forKey: UserCDAttr.avatarTemplate.rawValue)
        userCD.setValue(userModel.lastSeenAt, forKey: UserCDAttr.lastSeenAt.rawValue)
        userCD.setValue(userModel.moderator, forKey: UserCDAttr.moderator.rawValue)
        userCD.setValue(logged, forKey: UserCDAttr.logged.rawValue)
        
        do {
            try commit(message: "Error saving user: \(userModel). Logged: \(logged ?? false)")
        } catch {
            print("Error saving user: \(userModel)")
            throw error
        }
    }
    
    func saveDiscourseCategoryList(discourseCategoryList: [DiscourseCategory]) throws {
        do {
            try discourseCategoryList.forEach { dCategory in
                try saveDiscourseCategory(discourseCategory: dCategory)
            }
        } catch {
            print("Error saving category list: \(discourseCategoryList)")
            throw error
        }
        
    }
    
    func saveDiscourseCategory(discourseCategory: DiscourseCategory) throws {
        guard let context = provideObjectContext(),
            let entity = NSEntityDescription.entity(forEntityName: DatabaseEntities.DiscourseCategoryCD.rawValue,
                                                    in: context) else {
                                                        return
        }
        
        do {
            let discourseCategoryCD = DiscourseCategoryCD(entity: entity, insertInto: context)
            discourseCategoryCD.setValue(discourseCategory.id, forKey: DiscourseCategoryCDAttr.id.rawValue)
            discourseCategoryCD.setValue(discourseCategory.name , forKey: DiscourseCategoryCDAttr.name.rawValue)
            discourseCategoryCD.setValue(discourseCategory.color, forKey: DiscourseCategoryCDAttr.color.rawValue)
            discourseCategoryCD.setValue(discourseCategory.textColor, forKey: DiscourseCategoryCDAttr.textColor.rawValue)
            try commit(message: "Error saving category: \(discourseCategory)")
        } catch {
            print("Error saving category: \(discourseCategory)")
            throw error
        }
    }
    
    func savePrivateMessages(privateMessageList: [Topic]) throws {
        do {
            try privateMessageList.forEach { pMessage in
                try savePrivateMessage(privateMessage: pMessage)
            }
        } catch {
            print("Error saving private message list: \(privateMessageList)")
            throw error
        }
    }
                
    func saveTopic(data: Topic) throws {
        do {
            let _ = try TopicDataToCD(data: data)
            try commit(message: "Error saving single topic: \(data)")
        } catch {
            print("Error saving single topic: \(data)")
            throw error
        }
    }
    
    func savePrivateMessage(privateMessage: Topic) throws {
        do {
            try saveTopic(data: privateMessage)
        } catch {
            print("Error saving single topic: \(privateMessage)")
            throw error
        }
    }
        
    
    func saveTopicListResponse(topicListResponse: TopicListResponse) throws {
        do {
            let topicList = topicListResponse.topicList.topics
            try topicList.forEach { [weak self] topicData in
                try self?.updateOrSaveTopicWith(topicData: topicData)
            }
            let userList = topicListResponse.users
            try userList.forEach { [weak self] userData in
                try self?.updateOrSaveUserWith(userData: userData)
            }
            
        } catch (let error){
            print("Error saving tpoicListResponse: \(topicListResponse)")
            throw error
        }
        
    }
    
    func saveUserAvatarData(userAvatarData: UserAvatarModel) throws {
        guard let context = provideObjectContext(),
            let entity = NSEntityDescription.entity(forEntityName: DatabaseEntities.UserAvatarCD.rawValue, in: context)
            else { return }
        
        let userAvatarCD = UserAvatarCD(entity: entity, insertInto: context)
        userAvatarCD.setValue(userAvatarData.userId, forKey: UserAvatarCDAttr.userId.rawValue)
        userAvatarCD.setValue(userAvatarData.userAvatar, forKey: UserAvatarCDAttr.avatarTemplateImage.rawValue)
        do {
            try commit(message: "Error saving user avatar: \(userAvatarData)")
        } catch (let error) {
            print("Error saving user avatar: \(userAvatarData)")
            throw error
        }
    }

    // MARK: - LoadMethods
    func loadLoggedUser() throws -> User? {       
        do {
            // Get data from database
            guard let data = try loadLoggedUserCD() else {
                return nil
            }
            
            let user: User? = {
                guard let id = data.value(forKey: UserCDAttr.id.rawValue) as? Int,
                    let username = data.value(forKey: UserCDAttr.username.rawValue) as? String,
                    let name = data.value(forKey: UserCDAttr.name.rawValue) as? String,
                    let avatarTemplate = data.value(forKey: UserCDAttr.avatarTemplate.rawValue) as? String,
                    let lastSeenAt = data.value(forKey: UserCDAttr.lastSeenAt.rawValue) as? String?,
                    let moderator = data.value(forKey: UserCDAttr.moderator.rawValue) as? Bool?
                    else {
                        return nil
                }
                
                return User(id: id, username: username, name: name, avatarTemplate: avatarTemplate, lastSeenAt: lastSeenAt, moderator: moderator)
                
            }()
            
            return user
            
        } catch {
            print("Error fetching DirectoryItemCD data: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadLoggedUserCD() throws -> UserCD? {
        do {
            // Get data from database
            guard let data = try self.fetchDataRequestUsingType(UserCD.self,
                                                                predicate: "\(UserCDAttr.logged.rawValue) = true"),
                let userCD = data.first
                else {
                    return nil
            }
            
            return userCD
        } catch {
            print("Error fetching UserCD data: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadUserCDById(id: Int) throws -> UserCD? {
        do {
            // Get data from database
            guard let data = try self.fetchDataRequestUsingType(UserCD.self, predicate: "\(UserCDAttr.id.rawValue) = \(id)"),
                let userCD = data.first
                else {
                    return nil
            }
            
            return userCD
        } catch {
            print("Error fetching UserCD data: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadUserAvatarBy(userId: Int) throws -> Data? {
        do {
            if let userAvatarCD = try loadUserAvatarCDBy(userId: userId) {
                return userAvatarCD.avatarTemplateImage
            } else {
                return nil
            }
        } catch {
            print("Error fetching UserAvatar data: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadTopTopicsResponse() throws -> TopTopicsResponse? {
        do {
            // Get data from database
            guard let data = try self.fetchDataRequestUsingType(TopicCD.self, predicate: "\(TopicCDAttr.bumped.rawValue) = true") else {
                return nil
            }
            
            // Get TopicList
            var topicList = [Topic]()
            data.forEach { topicCD in
                topicList.append(TopicCDtoData(topicCD: topicCD))
            }
            
            var userList = [User]()
            try topicList.forEach { topic in
                if let topicOwnerId = topic.posters?.filter({ poster -> Bool in
                    poster.description.starts(with: "Original Poster")
                    }).first?.userId {
                    if let userCD = try loadUserCDById(id: topicOwnerId) {
                        userList.append(userCDToData(userCD: userCD))
                    }
                    
                }
            }
            
            return TopTopicsResponse(users: userList, topicList: TopicList(moreTopicsUrl: nil, topics: topicList))
            
        } catch (let error) {
            print("Error fetching topics data: \(error.localizedDescription)")
            throw error
        }
        
    }
    
    func loadLatestTopicsResponse() throws -> TopicListResponse? {
        do {
            // Get data from database
            guard let data = try self.fetchDataRequestUsingType(TopicCD.self, predicate: nil) else {
                return nil
            }
            
            // Get TopicList
            var topicList = [Topic]()
            data.forEach { topicCD in
                topicList.append(TopicCDtoData(topicCD: topicCD))
            }
            
            var userList = [User]()
            try topicList.forEach { topic in
                if let topicOwnerId = topic.posters?.filter({ poster -> Bool in
                    poster.description.starts(with: "Original Poster")
                }).first?.userId {
                    if let userCD = try loadUserCDById(id: topicOwnerId) {
                        userList.append(userCDToData(userCD: userCD))
                    }
                    
                }
            }
            
            return LatestTopicsResponse(users: userList, topicList: TopicList(moreTopicsUrl: nil, topics: topicList.sorted(by: { (t1, t2) -> Bool in
                t1.id < t2.id
            })))
            
        } catch (let error) {
            print("Error fetching topics data: \(error.localizedDescription)")
            throw error
        }
        
    }

    func loadPostListResponseBy(topicId: Int) throws -> SingleTopicResponse? {
        do {
            // Get data from database
            guard let data = try self.fetchDataRequestUsingType(TopicCD.self, predicate: "\(TopicCDAttr.id.rawValue) = \(topicId)")?.first else {
                return nil
            }
            
            // Get TopicList
            let topic = TopicCDtoData(topicCD: data)
            
            var userList = [User]()
            if let topicOwnerId = topic.posters?.filter({ poster -> Bool in
                poster.description.starts(with: "Original Poster")
            }).first?.userId {
                if let userCD = try loadUserCDById(id: topicOwnerId) {
                    userList.append(userCDToData(userCD: userCD))
                }
                
            }
            
            return SingleTopicResponse(postStream: topic.postStream, id: topic.id, title: topic.title, categoryId: topic.categoryId, details: topic.topicDetails, suggestedTopics: nil, views: topic.views ?? 0)
            
        } catch (let error) {
            print("Error fetching topics data: \(error.localizedDescription)")
            throw error
        }
    }
    
    func loadDiscourseCategoryListResponse() throws -> DiscourseCategoryListResponse? {
        do {
            // Get data from database
            guard let data = try self.fetchDataRequestUsingType(DiscourseCategoryCD.self) else {
                return nil
            }
            
            
            var discourseCategoryList = [DiscourseCategory]()
            // Get DiscourseCategoryList
            data.forEach { discourseCategoryCD in
                discourseCategoryList.append(discourseCategoryCDtoData(discourseCategoryCD: discourseCategoryCD))
            }
            
            return DiscourseCategoryListResponse(discourseCategoryList: DiscourseCategoryList(discourseCategories: discourseCategoryList))
            
        } catch (let error) {
            print("Error fetching discourse category data: \(error.localizedDescription)")
            throw error
        }
    }

    func loadUserBy(username: String) throws -> User? {
        do {
            // Get data from database
            guard let userCD = try self.fetchDataRequestUsingType(UserCD.self, predicate: "\(UserCDAttr.username.rawValue) = \"\(username)\"")?.first else {
                return nil
            }
            
            let id = Int(userCD.id)
            let name = userCD.name
            let avatarTemplate = userCD.avatarTemplate
            let lastSeenAt = userCD.lastSeenAt
            let moderator = userCD.moderator
            
            return User(id: id, username: username, name: name, avatarTemplate: avatarTemplate, lastSeenAt: lastSeenAt, moderator: moderator)
            
        } catch (let error) {
            print("Error loading user data: \(error.localizedDescription)")
            throw error
        }
    }

    
    // MARK: - Update Methods
    func updateOrSaveTopicWith(topicData: Topic) throws {
        guard let context = provideObjectContext(),
            let postStreamEntity = NSEntityDescription.entity(forEntityName: DatabaseEntities.PostStreamCD.rawValue, in: context),
            let topicsDetailEntity = NSEntityDescription.entity(forEntityName: DatabaseEntities.TopicDetailsCD.rawValue, in: context)
            else {
                return
        }
        do {
            guard let topicCD = try fetchDataRequestUsingType(TopicCD.self, predicate: "\(TopicCDAttr.id.rawValue) = \(topicData.id)"),
                let dataUpdate = topicCD.first else {
                    try saveTopic(data: topicData)
                    return
            }
            
            if let postStreamCD = dataUpdate.value(forKeyPath: TopicCDAttr.postStream.rawValue) as? PostStreamCD {
                try deleteData(data: [postStreamCD])
            }
            
            if let posts: [Post] = topicData.postStream?.posts {
                let postStreamCD = PostStreamCD(entity: postStreamEntity, insertInto: context)
                addPostsDataToPostStreamCD(posts: posts, postStreamCD: postStreamCD)
                dataUpdate.setValue(postStreamCD, forKeyPath: TopicCDAttr.postStream.rawValue)
                
            }
            
            if let topicDetailsCD = dataUpdate.value(forKeyPath: TopicCDAttr.topicDetails.rawValue) as? TopicDetailsCD {
                if let topicDetails = topicData.topicDetails {
                    addTopicDetailDataToTopicDetailsCD(topicDetails: topicDetails , topicDetailsCD: topicDetailsCD)
                    dataUpdate.setValue(topicDetailsCD, forKeyPath: TopicCDAttr.topicDetails.rawValue)
                }
            } else {
                let newTopicDetailsCD = TopicDetailsCD(entity: topicsDetailEntity, insertInto: context)
                if let topicDetails = topicData.topicDetails {
                    addTopicDetailDataToTopicDetailsCD(topicDetails: topicDetails , topicDetailsCD: newTopicDetailsCD)
                    dataUpdate.setValue(newTopicDetailsCD, forKeyPath: TopicCDAttr.topicDetails.rawValue)
                }
            }
            
            if let bumped: Bool = topicData.bumped {
                dataUpdate.setValue(bumped, forKey: TopicCDAttr.bumped.rawValue)
                
            }
            
            dataUpdate.setValue(topicData.id, forKey: TopicCDAttr.id.rawValue)
            dataUpdate.setValue(topicData.title, forKey: TopicCDAttr.title.rawValue)
            dataUpdate.setValue(topicData.categoryId, forKey: TopicCDAttr.categoryId.rawValue)
            if let archetype = topicData.archetype {
                dataUpdate.setValue(archetype, forKey: TopicCDAttr.archetype.rawValue)
            }
            if let createdAt = topicData.createdAt {
                dataUpdate.setValue(createdAt, forKey: TopicCDAttr.createdAt.rawValue)
            }
            
            if let posters = topicData.posters {
                try addPostersDataToTopicCD(posters: posters, topicCD: dataUpdate)
            }
            try commit(message: "Error updating topic: \(topicData)")
        } catch {
            print("Error updating topic: \(topicData)")
            throw error
        }
    }
    
    func updateOrSaveUserWith(userData: User) throws {
        do {
            guard let userCD = try fetchDataRequestUsingType(UserCD.self, predicate: "id = \(userData.id)"),
                let dataUpdate = userCD.first else {
                    try saveUserData(userModel: userData)
                    return
            }
            
            dataUpdate.setValue(userData.id, forKey: UserCDAttr.id.rawValue)
            dataUpdate.setValue(userData.name, forKey: UserCDAttr.name.rawValue)
            dataUpdate.setValue(userData.username, forKey: UserCDAttr.username.rawValue)
            dataUpdate.setValue(userData.avatarTemplate, forKey: UserCDAttr.avatarTemplate.rawValue)
            if (userData.lastSeenAt != nil) {
                dataUpdate.setValue(userData.lastSeenAt, forKey: UserCDAttr.lastSeenAt.rawValue)
            }
            dataUpdate.setValue(userData.moderator, forKey: UserCDAttr.moderator.rawValue)
            dataUpdate.setValue(dataUpdate.logged, forKey: UserCDAttr.logged.rawValue)
            
            try commit(message: "Error updating user: \(userData)")
        } catch {
            print("Error saving user: \(userData)")
            throw error
        }
        
    }
    
    func updateOrSavePostListResponseWith(postListResponse: SingleTopicResponse) throws {
        let topicData = Topic(id: postListResponse.id, title: postListResponse.title, postsCount: postListResponse.postStream?.posts.count ?? 0, views: nil, categoryId: nil, posters: nil, createdAt: nil, archetype: nil, postStream: postListResponse.postStream, topicDetails: nil, bumped: nil)
        do {
            try updateOrSaveTopicWith(topicData: topicData)
        } catch (let error) {
            print("Error updating or saving topic: \(postListResponse)")
            throw error
        }
    }
    
    func updateOrSaveUserAvatarWith(userAvatarData: UserAvatarModel) throws {
        do {
            guard let userAvatarCD = try fetchDataRequestUsingType(UserAvatarCD.self, predicate: "userId = \(userAvatarData.userId)"),
                let dataUpdate = userAvatarCD.first else {
                    try saveUserAvatarData(userAvatarData: userAvatarData)
                    return
            }
            
            dataUpdate.setValue(userAvatarData.userId, forKey: UserAvatarCDAttr.userId.rawValue)
            if let userAvatar = userAvatarData.userAvatar {
                dataUpdate.setValue(userAvatar, forKey: UserAvatarCDAttr.avatarTemplateImage.rawValue)
            }
            try commit(message: "Error updating user avatar: \(userAvatarData)")
        } catch {
            print("Error saving user avatar: \(userAvatarData)")
            throw error
        }
        
    }
    
    // MARK: - Delete Methods
    func deleteAllData(entity: DatabaseEntities) throws {
        guard let data = try fetchDataRequest(entity: entity.rawValue) else {
                return
        }
        
        do {
            try deleteData(data: data)
        } catch {
            print("Error deleting all data from: \(entity)")
            throw error
        }
        
    }
    
    func deleteUserBy(id: Int) throws {
        guard let data = try fetchDataRequestUsingType(UserCD.self, predicate: "\(UserCDAttr.id.rawValue) = \(id)") else {
                return
        }
        
        do {
            try deleteUserAvatarBy(userId: id)
            try deleteData(data: data)
        } catch {
            throw error
        }
        
    }

    func deleteTopicsByArchetype(archetype: TopicArchetype) throws {
        do {
            // Get data from database
            guard let data = try self.fetchDataRequest(entity: DatabaseEntities.TopicCD.rawValue,
                                                       predicate: "\(TopicCDAttr.archetype.rawValue) = \"\(archetype.rawValue)\"")
                else {
                    return
            }
            
            try deleteData(data: data)
            
        } catch {
            print("Error deleting TopicCD data: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteUserAvatarBy(userId: Int) throws {
        do {
            
            guard let data = try self.fetchDataRequestUsingType(UserAvatarCD.self,
                                                                predicate: "\(UserAvatarCDAttr.userId.rawValue) = \(userId)")
                else { return }
            
            try deleteData(data: data)
        } catch {
            print("Error deleting user avatar data from database: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Update Methods
    func logOutUserById(id: Int) throws {
        do {
            
            guard let data = try self.fetchDataRequestUsingType(UserCD.self, predicate: "\(UserCDAttr.id.rawValue) = \(id)"),
                let dataUpdate = data.first
                else {
                    return
            }
            
            // Update the entry in the context
            dataUpdate.setValue(false, forKey: UserCDAttr.logged.rawValue)
            
            try commit(message: "Error updating logged user: \(id)")
            
        } catch {
            print("Error updating single topic: \(id)")
            throw error
        }
        
    }

}

// MARK: - Protocol DatabaseCoreDataProtocol definition
protocol DatabaseCoreDataProtocol {
    func initDefaultData() throws
    func initDiscourseCategoryDefaultData() throws
    func initTopicListDefaultData() throws
    func saveLoggedUser(user: User) throws
    func loadLoggedUser() throws -> User?
    func loadUserAvatarBy(userId: Int) throws -> Data?
    func loadTopTopicsResponse() throws -> TopicListResponse?
    func loadLatestTopicsResponse() throws -> TopicListResponse?
    func loadPostListResponseBy(topicId: Int) throws -> SingleTopicResponse?
    func loadDiscourseCategoryListResponse() throws -> DiscourseCategoryListResponse?
    func loadUserBy(username: String) throws -> User?
    func logOutUserById(id: Int) throws
    func deleteUserBy(id: Int) throws
    func saveDiscourseCategoryList(discourseCategoryList: [DiscourseCategory]) throws
    func deleteTopicsByArchetype(archetype: TopicArchetype) throws
    func deletePrivateMessagesByArchetype(archetype: TopicArchetype) throws
    func saveTopicListResponse(topicListResponse: TopicListResponse) throws
    func updateOrSaveTopicWith(topicData: Topic) throws
    func updateOrSaveUserWith(userData: User) throws
    func updateOrSavePostListResponseWith(postListResponse: SingleTopicResponse) throws
    func updateOrSaveUserAvatarWith(userAvatarData: UserAvatarModel) throws
}
