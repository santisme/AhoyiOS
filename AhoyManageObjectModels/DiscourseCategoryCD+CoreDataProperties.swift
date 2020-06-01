//
//  DiscourseCategoryCD+CoreDataProperties.swift
//  
//
//  Created by Santiago Sanchez merino on 13/03/2020.
//
//

import Foundation
import CoreData


extension DiscourseCategoryCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiscourseCategoryCD> {
        return NSFetchRequest<DiscourseCategoryCD>(entityName: "DiscourseCategoryCD")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var textColor: String?

}
