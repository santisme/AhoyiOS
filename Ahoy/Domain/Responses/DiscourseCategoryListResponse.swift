//
//  DiscourseCategoryListResponse.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 06/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

struct DiscourseCategoryListResponse: Codable {
    let discourseCategoryList: DiscourseCategoryList
    
    enum CodingKeys: String, CodingKey {
        case discourseCategoryList = "category_list"
    }
}

// MARK: - CategoryList
struct DiscourseCategoryList: Codable {
    let discourseCategories: [DiscourseCategory]
    
    enum CodingKeys: String, CodingKey {
        case discourseCategories = "categories"
    }
}

// MARK: - DiscourseCategory
@objcMembers
class DiscourseCategory: NSObject, Codable {
    let id: Int
    let name: String
    let color: String
    let textColor: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
        case textColor = "text_color"
    }
    
    init(id: Int, name: String, color: String, textColor: String) {
        self.id = id
        self.name = name
        self.color = color
        self.textColor = textColor
    }
}
