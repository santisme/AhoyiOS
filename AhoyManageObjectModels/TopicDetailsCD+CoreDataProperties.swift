//
//  TopicDetailsCD+CoreDataProperties.swift
//  
//
//  Created by Santiago Sanchez merino on 13/03/2020.
//
//

import Foundation
import CoreData


extension TopicDetailsCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TopicDetailsCD> {
        return NSFetchRequest<TopicDetailsCD>(entityName: "TopicDetailsCD")
    }

    @NSManaged public var createdBy: CreatedByCD?
    @NSManaged public var topic: TopicCD?

}
