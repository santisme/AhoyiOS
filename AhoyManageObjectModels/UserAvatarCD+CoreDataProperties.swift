//
//  UserAvatarCD+CoreDataProperties.swift
//  
//
//  Created by Santiago Sanchez merino on 22/03/2020.
//
//

import Foundation
import CoreData


extension UserAvatarCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAvatarCD> {
        return NSFetchRequest<UserAvatarCD>(entityName: "UserAvatarCD")
    }

    @NSManaged public var avatarTemplateImage: Data?
    @NSManaged public var userId: Int16

}
