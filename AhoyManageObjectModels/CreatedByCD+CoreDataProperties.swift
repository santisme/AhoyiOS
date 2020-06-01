//
//  CreatedByCD+CoreDataProperties.swift
//  
//
//  Created by Santiago Sanchez merino on 16/03/2020.
//
//

import Foundation
import CoreData


extension CreatedByCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CreatedByCD> {
        return NSFetchRequest<CreatedByCD>(entityName: "CreatedByCD")
    }

    @NSManaged public var topicDetails: NSSet?
    @NSManaged public var user: UserCD?

}

// MARK: Generated accessors for topicDetails
extension CreatedByCD {

    @objc(addTopicDetailsObject:)
    @NSManaged public func addToTopicDetails(_ value: TopicDetailsCD)

    @objc(removeTopicDetailsObject:)
    @NSManaged public func removeFromTopicDetails(_ value: TopicDetailsCD)

    @objc(addTopicDetails:)
    @NSManaged public func addToTopicDetails(_ values: NSSet)

    @objc(removeTopicDetails:)
    @NSManaged public func removeFromTopicDetails(_ values: NSSet)

}
