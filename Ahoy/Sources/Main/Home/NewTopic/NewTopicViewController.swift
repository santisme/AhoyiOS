//
//  NewTopicViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 23/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class NewTopicViewController: UIViewController, AhoyBannerProtocol {
    // MARK: - Private Properties
    private lazy var delegate: NewTopicViewControllerDelegate = {
        NewTopicModelView(view: self, topicRepository: LocalRepository())
    }()
    private let rawPlaceholder: String = "Topic content"
    private var discourseCategory: DiscourseCategory? = nil
    
    // MARK: - Outlets
    @IBOutlet weak var topicTitleTextField: DesignableTextField!
    @IBOutlet weak var topicContent: UITextView!
    @IBOutlet weak var topicCategoryTextField: DesignableTextField!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    deinit {
        unregisterForKeyboardNotifications()
    }
    
    // MARK: - Actions
    @IBAction func cancelClicked(_ sender: UIButton) {
        delegate.cancelClicked()
    }
    
    @IBAction func sendTopicClicked(_ sender: UIButton) {
        delegate.sendTopicClicked(newTopicModel: NewTopicModel(title: topicTitleTextField.text ?? "", discourseCategory: discourseCategory, raw: topicContent.text, createdAt: getCurrentDateTime()))
    }
    
    @IBAction func discourseCategoryClicked(_ sender: Any) {
        topicCategoryTextField.text = ""
        delegate.discourseCategoryClicked()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        topicContent.delegate = self
        setTopicContentPlaceHolder()
        
        registerForKeyboardNotifications(actionSelector: manageKeyboard)
        topicTitleTextField.becomeFirstResponder()
    }
    
    private func getCurrentDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyyThh:mm:ssZ"
        return dateFormatter.string(from: Date())
    }
    
    private func setTopicContentPlaceHolder() {
        topicContent.textColor = AhoyUIResources.factory.color(usage: .ahoyPlaceHolder)
        topicContent.text = rawPlaceholder
    }
    
    private func cleanTopicContent() {
        topicContent.text = ""
        topicContent.textColor = AhoyUIResources.factory.color(usage: .ahoyMainTextColor)
    }
}

// MARK: - Extension KeyboarManagerProtocol implementation
extension NewTopicViewController: KeyboarManagerProtocol {
    var manageKeyboard: Selector {
            return #selector(manageKB)
        }
        
        @objc
        private func manageKB(_ notification: Notification) {
            guard let userInfo = notification.userInfo,
                let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                else {
                    print("[Error] Something in KeyboardResizedContainerView went wrong.")
                    return
            }
            
            let keyboardViewEndFrame = view.convert(keyboardFrame, from: view.window)
            let isShowingKeyboard = (notification.name == UIResponder.keyboardWillShowNotification) ? true : false
            let size = keyboardViewEndFrame.height - view.safeAreaInsets.bottom
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
            
            if (isShowingKeyboard) {
                if (self.topicContent.contentInset.bottom < size) {
                    animateKeyboard(size: size, duration: duration)
                }
                
            } else {
                animateKeyboard(size: .zero, duration: duration)
            }
        }
    
    func animateKeyboard(size: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.topicContent.contentInset.bottom = size
            self?.view.layoutIfNeeded()
            
        })
    }
    
}

extension NewTopicViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            setTopicContentPlaceHolder()
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == rawPlaceholder {
            cleanTopicContent()
        }
    }
}


// MARK: - Extension NewTopicModelViewProtocol implementation
extension NewTopicViewController: NewTopicModelViewProtocol {
    func showError(message: String) {
        showErrorBanner(message: message)
    }
    
    func showSuccess(message: String) {
        showSuccessBanner(message: message)
    }
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigateToChooseDiscourseCategory() {
        let chooseDiscouserCategoryViewController = ChooseDiscourseCategoryViewController(requester: self)
        present(chooseDiscouserCategoryViewController, animated: true, completion: nil)
    }
}

extension NewTopicViewController: ChooseDiscourseCategoryRequesterProtocol {
    func updateDiscourseCategory(discourseCategory: DiscourseCategory) {
        self.discourseCategory = discourseCategory
        DispatchQueue.main.async { [weak self] in
            self?.topicCategoryTextField.text = discourseCategory.name
            self?.topicCategoryTextField.resignFirstResponder()
        }
    }

}

// MARK: - Protocol NewTopicViewControllerDelegate definition
protocol NewTopicViewControllerDelegate: class {
    func sendTopicClicked(newTopicModel: NewTopicModel)
    func cancelClicked()
    func discourseCategoryClicked()
}
