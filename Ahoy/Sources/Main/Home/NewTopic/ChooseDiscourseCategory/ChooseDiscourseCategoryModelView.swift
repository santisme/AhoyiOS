//
//  ChooseDiscourseCategoryModelView.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 23/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import Foundation

final class ChooseDiscourseCategoryModelView {
    private let view: ChooseDiscourseCategoryModelViewProtocol?
    private let discourseCategoryRepository: LocalRepository
    
    init(view: ChooseDiscourseCategoryModelViewProtocol? = nil, discourseCategoryRepository: LocalRepository) {
        self.view = view
        self.discourseCategoryRepository = discourseCategoryRepository
    }
    
}



extension ChooseDiscourseCategoryModelView: ChooseDiscourseCategoryDelegate {
    func viewDidLoad() {
        do {
            if let discourseCategoryListResponse = try discourseCategoryRepository.loadDiscourseCategoryListResponse() {
                view?.updateModel(model: discourseCategoryListResponse.discourseCategoryList.discourseCategories)
            }
        } catch (let error) {
            view?.showError(message: "Error loading discourse categories from database")
            print("Error loading discourse categories from database: \(error.localizedDescription)")
        }
    }
    
    func discourseCategorySelected(discourseCategory: DiscourseCategory) {
        view?.dissmisView(discourseCategory: discourseCategory)
    }

}

protocol ChooseDiscourseCategoryModelViewProtocol: class {
    func updateModel(model: [DiscourseCategory])
    func showError(message: String)
    func dissmisView(discourseCategory: DiscourseCategory)
}
