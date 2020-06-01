//
//  TopicCD+CoreDataProperties.swift
//  
//
//  Created by Santiago Sanchez merino on 16/03/2020.
//
//

import Foundation
import CoreData


extension TopicCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopicCD> {
        return NSFetchRequest<TopicCD>(entityName: "TopicCD")
    }

    @NSManaged public var archetype: String?
    @NSManaged public var categoryId: Int16
    @NSManaged public var createdAt: String?
    @NSManaged public var id: Int16
    @NSManaged public var postsCount: Int16
    @NSManaged public var title: String?
    @NSManaged public var views: Int16
    @NSManaged public var bumped: Bool
    @NSManaged public var posters: NSSet?
    @NSManaged public var postStream: PostStreamCD?
    @NSManaged public var topicDetails: TopicDetailsCD?

}

// MARK: Generated accessors for posters
extension TopicCD {

    @objc(addPostersObject:)
    @NSManaged public func addToPosters(_ value: PosterCD)

    @objc(removePostersObject:)
    @NSManaged public func removeFromPosters(_ value: PosterCD)

    @objc(addPosters:)
    @NSManaged public func addToPosters(_ values: NSSet)

    @objc(removePosters:)
    @NSManaged public func removeFromPosters(_ values: NSSet)

}
