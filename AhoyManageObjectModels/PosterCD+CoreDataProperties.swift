//
//  PosterCD+CoreDataProperties.swift
//  
//
//  Created by Santiago Sanchez merino on 13/03/2020.
//
//

import Foundation
import CoreData


extension PosterCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PosterCD> {
        return NSFetchRequest<PosterCD>(entityName: "PosterCD")
    }

    @NSManaged public var posterDescription: String?
    @NSManaged public var topic: NSSet?
    @NSManaged public var userId: UserCD?

}

// MARK: Generated accessors for topic
extension PosterCD {

    @objc(addTopicObject:)
    @NSManaged public func addToTopic(_ value: TopicCD)

    @objc(removeTopicObject:)
    @NSManaged public func removeFromTopic(_ value: TopicCD)

    @objc(addTopic:)
    @NSManaged public func addToTopic(_ values: NSSet)

    @objc(removeTopic:)
    @NSManaged public func removeFromTopic(_ values: NSSet)

}
