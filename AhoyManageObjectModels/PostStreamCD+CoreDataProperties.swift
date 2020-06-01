//
//  PostStreamCD+CoreDataProperties.swift
//  
//
//  Created by Santiago Sanchez merino on 13/03/2020.
//
//

import Foundation
import CoreData


extension PostStreamCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostStreamCD> {
        return NSFetchRequest<PostStreamCD>(entityName: "PostStreamCD")
    }

    @NSManaged public var posts: NSSet?
    @NSManaged public var singleTopic: TopicCD?

}

// MARK: Generated accessors for posts
extension PostStreamCD {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: PostCD)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: PostCD)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
