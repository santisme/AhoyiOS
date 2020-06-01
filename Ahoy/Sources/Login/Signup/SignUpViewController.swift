//
//  SignUpViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit
import NotificationBannerSwift

final class SignUpViewController: UIViewController, AhoyBannerProtocol {
    
    // MARK: - Private Properties
    private var delegate: SignUpViewControllerDelegate? = nil
    private var signUpModelWrapper: SignUpModelWrapper {
        SignUpModelWrapper(signUpModel: SignUpModel(name: name.text ?? "", email: email.text ?? "", password: password.text ?? "", username: username.text ?? ""), repeatedPassword: repeatedPassword.text ?? "")
    }
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var name: DesignableTextField!
    @IBOutlet weak var username: DesignableTextField!
    @IBOutlet weak var password: DesignableTextField!
    @IBOutlet weak var repeatedPassword: DesignableTextField!
    @IBOutlet weak var email: DesignableTextField!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    deinit {
        unregisterForKeyboardNotifications()
    }
    
    // MARK: - IBActions
    @IBAction func signUpClicked(_ sender: DesignableButton) {
        view.endEditing(true)
        delegate?.signUpClicked(signUpModelWrapper: signUpModelWrapper)
    }
    
    @IBAction func signInClicked(_ sender: DesignableButton) {
        view.endEditing(true)
        delegate?.signInClicked()
    }
    
    @IBAction func passwordRecoveryClicked(_ sender: DesignableButton) {
        view.endEditing(true)
        delegate?.passwordRecoveryClicked()
    }
    
    @IBAction func usernameEditingDidEnd(_ sender: DesignableTextField) {
        delegate?.usernameEditingDidEnd(sender: sender)
    }
    
    @IBAction func passwordEditingDidEnd(_ sender: DesignableTextField) {
        delegate?.passwordEditingDidEnd(sender: sender)
    }
    
    @IBAction func repeatedPasswordEditingDidEnd(_ sender: DesignableTextField) {
        delegate?.repeatedPasswordEditingDidEnd(passwordTextField: password, sender: sender)
    }
    
    @IBAction func emailEditingDidEnd(_ sender: DesignableTextField) {
        delegate?.emailEditingDidEnd(sender: sender)
    }
    
    
    // MARK: - Private Methods
    private func setupView() {
        navigationController?.isNavigationBarHidden = true
        
        clearForm()
        
        username.textContentType = .username
        email.keyboardType = .emailAddress
        email.textContentType = .emailAddress
        password.textContentType = .newPassword
        password.isSecureTextEntry = true
        repeatedPassword.textContentType = .newPassword
        repeatedPassword.isSecureTextEntry = true
        repeatedPassword.returnKeyType = .go
        
        delegate = SignUpModelView(view: self, signUpRepository: LocalRepository())
        
        registerForKeyboardNotifications(actionSelector: manageKeyboard)
        
    }
}

// MARK: - Extension KeyboarManagerProtocol implementation
extension SignUpViewController: KeyboarManagerProtocol {
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

// MARK: - Extension SignUpViewControllerProtocol implementation
extension SignUpViewController: SignUpModelViewProtocol {
    func showError(message: String) {
        showErrorBanner(message: message)
    }
    
    func showSuccess(message: String) {
        showSuccessBanner(message: message)
    }
    
    func clearForm() {
        name.text = ""
        username.text = ""
        email.text = ""
        password.text = ""
        repeatedPassword.text = ""
    }
    
    func navigateToSignIn() {
        navigationController?.popViewController(animated: true)
    }
    
    func navigateToPasswordRecovery() {
        let passwordRecoveryViewController = PasswordRecoveryViewController()
        passwordRecoveryViewController.modalPresentationStyle = .fullScreen
        present(passwordRecoveryViewController, animated: true)
    }
}

// MARK: - Protocol SignUpViewControllerDelegate
protocol SignUpViewControllerDelegate: class {
    func usernameEditingDidEnd(sender: DesignableTextField)
    func passwordEditingDidEnd(sender: DesignableTextField)
    func repeatedPasswordEditingDidEnd(passwordTextField: DesignableTextField, sender: DesignableTextField)
    func emailEditingDidEnd(sender: DesignableTextField)
    func signUpClicked(signUpModelWrapper: SignUpModelWrapper)
    func signInClicked()
    func passwordRecoveryClicked()
}
