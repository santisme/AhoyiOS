//
//  UserDetailViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit
import NotificationBannerSwift

final class UserDetailViewController: UIViewController, AhoyBannerProtocol {

    // MARK: - Private Properties
    private var delegate: UserDetailViewControllerDelegate? = nil
    private var userDetailModel: UserDetailModel? = nil
    
    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastConnectionLabel: UILabel!
    @IBOutlet weak var privateMessagesCountLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    // MARK: - IBActions
    @IBAction func logOutButtonClicked(_ sender: UIButton) {
        if let model = userDetailModel {
            delegate?.logOutButtonClicked(userDetailModel: model)
        }
    }
    
    // MARK: - Private Methods
    private func setupView() {
        nameLabel.text = ""
        nickNameLabel.text = ""
        lastConnectionLabel.text = ""
        privateMessagesCountLabel.text = "0"
        logOutButton.isEnabled = false
        
        delegate = UserDetailModelView(view: self, userDetailRepository: LocalRepository())
        delegate?.loadUserDetailModel()
        disableLogOutButton()
        updateView()
    }
    
    private func updateView() {
        guard let model = userDetailModel else {
            return
        }
        
        delegate?.loadUserDetailAvatar(avatarTemplate: model.avatarTemplate ?? "")
        
        statusLabel.textColor = (model.moderator ?? false) ? UIColor.systemGreen : AhoyUIResources.factory.color(usage: Color.ahoyGray)
        nameLabel.text = model.name
        nickNameLabel.text = model.username
        let lastSeenAt = TimeOffsetRepository.factory.getTimeOffset(dateToCompareString: model.lastSeenAt ?? "Unknown")
        lastConnectionLabel.text = (lastSeenAt.amount > 1) ? "\(lastSeenAt.amount) \(lastSeenAt.unit)s" : "\(lastSeenAt.amount) \(lastSeenAt.unit)"
        logOutButton.isEnabled = (model.logged) ? true : false
        
    }
    
    private func enableLogOutButton() {
        logOutButton.isEnabled = true
    }

    private func disableLogOutButton() {
        logOutButton.isEnabled = false
    }

}

// MARK: - Extension UserDetailModelViewProtocol implementation
extension UserDetailViewController: UserDetailModelViewProtocol {
  
        func showError(message: String) {
            showErrorBanner(message: message)
        }
        
        func showSuccess(message: String) {
            showSuccessBanner(message: message)
        }
    
    func updateModel(userDetailModel: UserDetailModel) {
        self.userDetailModel = userDetailModel
    }
    
    func updateAvatar(userAvatar: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.avatarImageView.image = userAvatar
            self?.avatarImageView.setNeedsLayout()
        }

    }
    
    func logOut() {
        let signInViewController = SignInViewController()
        
        UIApplication.shared.windows.filter{ $0.isKeyWindow }.first?.rootViewController = UINavigationController(rootViewController: signInViewController)
        
//        dismiss(animated: true, completion: nil)
    }
    
    func updatePrivateMessagesCount(count: Int) {
        privateMessagesCountLabel.text = "\(count)"
        privateMessagesCountLabel.setNeedsLayout()
    }
        
}

// MARK: - Protocol UserDetailViewControllerDelegate definition
protocol UserDetailViewControllerDelegate: class {
    func loadUserDetailModel()
    func loadUserDetailAvatar(avatarTemplate: String)
    func logOutButtonClicked(userDetailModel: UserDetailModel)
}
