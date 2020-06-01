//
//  SignInViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 25/02/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit
import NotificationBannerSwift

final class SignInViewController: UIViewController, AhoyBannerProtocol {
    
    // MARK: - Private Properties
    private var delegate: SignInViewControllerDelegate? = nil
    private var signInModel: SignInModel {
        SignInModel(username: username.text ?? "", password: password.text ?? "")
        
    }
    
    // MARK: - Outlets
    @IBOutlet weak var username: DesignableTextField!
    @IBOutlet weak var password: DesignableTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    deinit {
        unregisterForKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Actions
    @IBAction func signInClicked(_ sender: DesignableButton) {
        view.endEditing(true)
        delegate?.signInClicked(signInModel: signInModel)
    }
    
    @IBAction func signUpClicked(_ sender: DesignableButton) {
        view.endEditing(true)
        delegate?.signUpClicked()
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
    
    // MARK: - Private Methods
    private func setupView() {
        // This must be in first place
        delegate = SignInModelView(view: self, signInRepository: LocalRepository())
        
        navigationController?.isNavigationBarHidden = true
        
        clearForm()
        
        username.textContentType = .username
        username.clearButtonMode = .always
        password.textContentType = .password
        password.clearButtonMode = .always
        password.isSecureTextEntry = true
        password.returnKeyType = .go
        
        registerForKeyboardNotifications(actionSelector: manageKeyboard)
    }
    
    private func lookForActiveLogin() {
        delegate?.lookForActiveLogin()
    }
}

// MARK: - Extension KeyboarManagerProtocol implementation
extension SignInViewController: KeyboarManagerProtocol {
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

// MARK: - Extension to implement SignInModelViewProtocol
extension SignInViewController: SignInModelViewProtocol {
    func showError(message: String) {
        showErrorBanner(message: message)
        
    }
    
    func showSuccess(message: String) {
        showSuccessBanner(message: message)
        
    }
    
    func clearForm() {
        username.text = ""
        password.text = ""
    }
    
    func navigateToSignUp() {
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)

    }
    
    func navigateToMainViewController() {
        let mainViewController = MainViewController()
        mainViewController.modalPresentationStyle = .fullScreen
        present(mainViewController, animated: true, completion: nil)
    }
    
    func navigateToPasswordRecovery() {
        let passwordRecoveryViewController = PasswordRecoveryViewController()
        passwordRecoveryViewController.modalPresentationStyle = .fullScreen
        present(passwordRecoveryViewController, animated: true)
    }
    
    func passwordFound(password: String) {
        showSuccess(message: "Password for username \(username.text ?? "") found in keychain.")
        self.password.text = password

//        let alertView = UIAlertController(title: "Keychain", message: "Click OK to use the password found in keychain?", preferredStyle: .actionSheet)
//        let alertSaveAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
//            self?.password.text = password
//        }
//        
//        let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        alertView.addAction(alertSaveAction)
//        alertView.addAction(alertCancelAction)
//        username.resignFirstResponder()
//        present(alertView, animated: true, completion: nil)
    }
    
    func askForSavingCredentialInKeychain(completion: @escaping () -> ()) {
        let alertView = UIAlertController(title: "Keychain", message: "Click OK to save this credential in keychain?", preferredStyle: .actionSheet)
        let alertSaveAction = UIAlertAction(title: "OK", style: .default) { [weak self] action in
            self?.delegate?.savePasswordInKeychain()
            completion()
        }
        
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            completion()
        }
        
        alertView.addAction(alertSaveAction)
        alertView.addAction(alertCancelAction)
        password.resignFirstResponder()
        present(alertView, animated: true)
    }
}

// MARK: - Protocol SignInViewControllerDelegate
protocol SignInViewControllerDelegate: class {
    func signInClicked(signInModel: SignInModel)
    func signUpClicked()
    func passwordRecoveryClicked()
    func usernameEditingDidEnd(sender: DesignableTextField)
    func passwordEditingDidEnd(sender: DesignableTextField)
    func lookForActiveLogin()
    func savePasswordInKeychain()
}
