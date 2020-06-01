//
//  NewPostViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 21/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class NewPostViewController: UIViewController, AhoyBannerProtocol {
    // MARK: - Private Properties
    private lazy var delegate: NewPostViewControllerDelegate = {
        NewPostModelView(view: self, postRepository: LocalRepository(), topicId: self.topicId)
    }()
    private let topicId: Int
    
    // MARK: - Outlets
    @IBOutlet weak var postContent: UITextView!
    @IBOutlet weak var send: UIButton!

    // MARK: - Inits
    init(topicId: Int) {
        self.topicId = topicId
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

    deinit {
        unregisterForKeyboardNotifications()
    }
    
    // MARK: - Actions
    @IBAction func cancelClicked(_ sender: UIButton) {
        delegate.cancelClicked()
    }
    
    @IBAction func sendPostClicked(_ sender: UIButton) {
        postContent.resignFirstResponder()
        delegate.sendPostClicked(postContent: postContent.text)
    }
    
    // MARK: - Private Methods
    private func setupView() {
        
        postContent.text = ""
        
        registerForKeyboardNotifications(actionSelector: manageKeyboard)
        postContent.becomeFirstResponder()
    }
}

// MARK: - Extension KeyboarManagerProtocol implementation
extension NewPostViewController: KeyboarManagerProtocol {
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
                if (self.postContent.contentInset.bottom < size) {
                    animateKeyboard(size: size, duration: duration)
                }
                
            } else {
                animateKeyboard(size: .zero, duration: duration)
            }
        }
    
    func animateKeyboard(size: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.postContent.contentInset.bottom = size
            self?.view.layoutIfNeeded()
            
        })
    }
    
}

// MARK: - Extension NewPostModelViewProtocol protocol implementation
extension NewPostViewController: NewPostModelViewProtocol {
    func showError(message: String) {
        showErrorBanner(message: message)
    }
    
    func showSuccess(message: String) {
        showSuccessBanner(message: message)
    }    
    
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Protocol NewPostViewControllerDelegate definition
protocol NewPostViewControllerDelegate: class {
    func sendPostClicked(postContent: String?)
    func cancelClicked()
}
