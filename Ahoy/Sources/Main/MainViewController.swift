//
//  MainViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit
import NotificationBannerSwift

final class MainViewController: UITabBarController {
    // MARK: - Private Properties
    private var vcDelegate: MainViewControllerDelegate? = nil
    weak var homeView: MainViewControllerProtocol? = nil
    
    // MARK: - Outlets
    @IBOutlet weak var mainTabBar: UITabBar!
    @IBOutlet weak var homeBarItem: UITabBarItem!
    @IBOutlet weak var privateMessagesBarItem: UITabBarItem!
    @IBOutlet weak var userDetailBarItem: UITabBarItem!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        vcDelegate?.lookForActiveLogin()
        
    }
    
    // MARK: - Private Methods
    private func setupView() {
        vcDelegate = MainModelView(view: self, userDetailRepository: LocalRepository())
        delegate = self
        
        let homeViewController = HomeViewController()
        let privateMessagesViewController = PrivateMessagesViewController()
        let userDetailViewController = UserDetailViewController()
        
        let controllers = [homeViewController, privateMessagesViewController, userDetailViewController]
        viewControllers = controllers.map { UINavigationController(rootViewController: $0) }
        
        homeView = homeViewController
        
        homeViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        
        privateMessagesViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bubble.left"), selectedImage: UIImage(systemName: "bubble.left.fill"))
        userDetailViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
    }
    
}


// MARK: - Extension MainModelViewProtocol implementation
extension MainViewController: MainModelViewProtocol {
    func noActiveLoginFound() {
        let signInViewController = SignInViewController()
        
        UIApplication.shared.windows.filter{ $0.isKeyWindow }.first?.rootViewController = UINavigationController(rootViewController: signInViewController)
        
    }
    
    func showError(message: String) {
        let banner = StatusBarNotificationBanner(title: message, style: .danger)
        banner.titleLabel?.font = AhoyUIResources.factory.font(style: .banner14semibold)
        banner.show(queuePosition: .front, bannerPosition: .top, queue: .default, on: navigationController?.presentingViewController)
    }
    
    func showSuccess(message: String) {
        let banner = StatusBarNotificationBanner(title: message, style: .success)
        banner.titleLabel?.font = AhoyUIResources.factory.font(style: .banner14semibold)
        banner.show(queuePosition: .front, bannerPosition: .top, queue: .default, on: navigationController?.presentingViewController)
    }
}

// MARK: - Extension UITabBarControllerDelegate protocol implementation
extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 0 {
            homeView?.resetHomePage()
        }
    }
}

// MARK: - Protocol MainViewControllerDelegate definition
protocol MainViewControllerDelegate: class {
    func lookForActiveLogin()
}

// MARK: - Protocol MainViewControllerProtocol definition
// To interact with HomeViewController
protocol MainViewControllerProtocol: class {
    func resetHomePage()
}
