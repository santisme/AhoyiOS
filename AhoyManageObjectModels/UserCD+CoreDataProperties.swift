//
//  UserCD+CoreDataProperties.swift
//  
//
//  Created by Santiago Sanchez merino on 16/03/2020.
//
//

import Foundation
import CoreData


extension UserCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCD> {
        return NSFetchRequest<UserCD>(entityName: "UserCD")
    }

    @NSManaged public var avatarTemplate: String?
    @NSManaged public var id: Int16
    @NSManaged public var lastSeenAt: String?
    @NSManaged public var logged: Bool
    @NSManaged public var moderator: Bool
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var poster: NSSet?
    @NSManaged public var createdBy: CreatedByCD?

}

// MARK: Generated accessors for poster
extension UserCD {

    @objc(addPosterObject:)
    @NSManaged public func addToPoster(_ value: PosterCD)

    @objc(removePosterObject:)
    @NSManaged public func removeFromPoster(_ value: PosterCD)

    @objc(addPoster:)
    @NSManaged public func addToPoster(_ values: NSSet)

    @objc(removePoster:)
    @NSManaged public func removeFromPoster(_ values: NSSet)

}
