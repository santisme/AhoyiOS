//
//  PostCD+CoreDataProperties.swift
//  
//
//  Created by Santiago Sanchez merino on 25/03/2020.
//
//

import Foundation
import CoreData


extension PostCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostCD> {
        return NSFetchRequest<PostCD>(entityName: "PostCD")
    }

    @NSManaged public var avatarTemplate: String?
    @NSManaged public var cooked: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var updatedAt: String?
    @NSManaged public var username: String?
    @NSManaged public var blurb: String?
    @NSManaged public var raw: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var topicId: Int16
    @NSManaged public var postStream: PostStreamCD?

}
