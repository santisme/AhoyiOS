//
//  PasswordRecoveryViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 27/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit
import NotificationBannerSwift

final class PasswordRecoveryViewController: UIViewController, AhoyBannerProtocol {

    // MARK: - Private Properties
    private var delegate: PasswordRecoveryViewControllerDelegate? = nil
    private var passwordRecoveryModel: PasswordRecoveryModel {
        PasswordRecoveryModel(login: username.text ?? "")
        
    }
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var username: DesignableTextField!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    deinit {
        unregisterForKeyboardNotifications()
    }
    
    // MARK: - Actions
    @IBAction func resetPasswordClicked(_ sender: DesignableButton) {
        view?.endEditing(true)
        delegate?.resetPasswordClicked(passwordRecoveryModel: passwordRecoveryModel)
    }
    
    @IBAction func cancelClicked(_ sender: DesignableButton) {
        view?.endEditing(true)
        delegate?.cancelClicked()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        clearForm()
        delegate = PasswordRecoveryModelView(view: self, passwordRecoveryRepository: LocalRepository())
        
        registerForKeyboardNotifications(actionSelector: manageKeyboard)
    }

}

// MARK: - Extension KeyboarManagerProtocol implementation
extension PasswordRecoveryViewController: KeyboarManagerProtocol {
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
            if (self.scrollView.contentInset.bottom < size) {
                animateKeyboard(size: size, duration: duration)
            }

        } else {
            animateKeyboard(size: .zero, duration: duration)
        }
    }
    
    func animateKeyboard(size: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.scrollView.contentInset.bottom = size
            self?.scrollView.verticalScrollIndicatorInsets.bottom = size
            self?.view.layoutIfNeeded()

        })
        
    }
    
}

extension PasswordRecoveryViewController: PasswordRecoveryModelViewProtocol {
    func showError(message: String) {
        showErrorBanner(message: message)
    }
    
    func showSuccess(message: String) {
        showSuccessBanner(message: message)
    }
    
    func clearForm() {
        username.text = ""
    }
    
    func dismissViewController() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
}

protocol PasswordRecoveryViewControllerDelegate: class {
    func resetPasswordClicked(passwordRecoveryModel: PasswordRecoveryModel)
    func cancelClicked()
}
