//
//  ChooseDiscourseCategoryViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 23/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

class ChooseDiscourseCategoryViewController: UIViewController, AhoyBannerProtocol {
    // MARK: - Private Properties
    private var requester: ChooseDiscourseCategoryRequesterProtocol?
    private var model = [DiscourseCategory]()
    private lazy var delegate: ChooseDiscourseCategoryDelegate = {
        ChooseDiscourseCategoryModelView(view: self, discourseCategoryRepository: LocalRepository())
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var discourseCategoryPicker: UIPickerView!
    
    // MARK: - Inits
    init(requester: ChooseDiscourseCategoryRequesterProtocol? = nil) {
        self.requester = requester
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Private Methods
    private func setupView() {
        delegate.viewDidLoad()
        discourseCategoryPicker.dataSource = self
        discourseCategoryPicker.delegate = self
    }
}

extension ChooseDiscourseCategoryViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        model.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        model[row].name
    }
    
}

extension ChooseDiscourseCategoryViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate.discourseCategorySelected(discourseCategory: model[row])
    }
}

extension ChooseDiscourseCategoryViewController: ChooseDiscourseCategoryModelViewProtocol {
    func updateModel(model: [DiscourseCategory]) {
        self.model = model
    }
    
    func showError(message: String) {
        showErrorBanner(message: message)
    }
    
    func dissmisView(discourseCategory: DiscourseCategory) {
        requester?.updateDiscourseCategory(discourseCategory: discourseCategory)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Protocol ChooseDiscourseCategoryDelegate definition
protocol ChooseDiscourseCategoryDelegate: class {
    func viewDidLoad()
    func discourseCategorySelected(discourseCategory: DiscourseCategory)
}

// MARK: - Protocl ChooseDiscourseCategoryRequesterProtocol definition
// Used to send back the choosen category to the requester ViewController
protocol ChooseDiscourseCategoryRequesterProtocol: class {
    func updateDiscourseCategory(discourseCategory: DiscourseCategory)
}
