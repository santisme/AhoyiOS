//
//  HomeViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit
import NotificationBannerSwift

final class HomeViewController: UIPageViewController, AhoyBannerProtocol {
    // MARK: - Private Properties
    private var viewControllerList: [UIViewController] = []
    //    private lazy var viewControllerList: [UIViewController] = {
    //        return [TopicListViewController(navigation: self), TopicFilterViewController(navigation: self)]
    //    }()
    
    private lazy var pageControl: UIPageControl = {
        return UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
    }()
    
    weak var homeDelegate: HomeViewControllerDelegate? = nil
    private var scrollDirection: UIPageViewController.NavigationDirection = .reverse
    private var topicFilterName: String = TopicFilterType.latest.rawValue {
        didSet {
            titleView.text = topicFilterName
        }
    }
    private let titleView = UILabel()
    
    // MARK: - Inits
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollToFirstViewController()
    }
    
    // MARK: - Private Functions
    private func setupView() {
        
        let topicListViewController = TopicListViewController()
        let topicFilterViewController = TopicFilterViewController(navigation: self)
        viewControllerList = [topicListViewController, topicFilterViewController]
        self.homeDelegate = topicListViewController
        
        // Set UIPageViewController Datasource and delegate
        self.topicFilterName = TopicFilterType.latest.rawValue
        dataSource = self
        
        setupNavigation()
        
    }
    
    private func setupNavigation() {
        topicFilterName = TopicFilterType.latest.rawValue
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .plain, target: self, action: #selector(burguerMenuClicked))
        leftBarButtonItem.tintColor = AhoyUIResources.factory.color(usage: .ahoyLigthBlue)
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: true)
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchClicked))
        rightBarButtonItem.tintColor = AhoyUIResources.factory.color(usage: .ahoyLigthBlue)
        self.navigationItem.setRightBarButton(rightBarButtonItem, animated: true)
        
        titleView.font = AhoyUIResources.factory.font(style: .navigation16Bold)
        titleView.sizeToFit()
        self.navigationItem.titleView = titleView
    }
    
    private func scrollToFirstViewController() {
        guard let firstViewController = viewControllerList.first else {
            return
        }
        scrollToViewController(viewController: firstViewController, direction: .forward)
        
    }
    
    private func scrollToViewController(viewController: UIViewController, direction: UIPageViewController.NavigationDirection = .forward) {
        setViewControllers([viewController], direction: direction, animated: true, completion: nil)
    }
    
    @objc
    private func burguerMenuClicked() {
        guard let lastViewController = viewControllerList.last else {
            return
        }
        scrollToViewController(viewController: lastViewController, direction: .reverse)
    }
    
    @objc
    private func searchClicked() {
        let topicSearchViewController = TopicSearchViewController(navigation: self)
        topicSearchViewController.modalPresentationStyle = .overCurrentContext
        topicSearchViewController.modalTransitionStyle = .crossDissolve
        present(topicSearchViewController, animated: true, completion: nil)
    }
}

// MARK: - Extension UIPageViewControllerDataSource
extension HomeViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewControllerList.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else {
            return nil
        }
        
        switch scrollDirection {
        case .reverse:
            // To scroll the views from right to left
            if (viewControllerIndex == viewControllerList.count - 1) {
                return nil
            } else {
                return viewControllerList.last
            }
        default:
            // To scroll the views from left to right
            if (viewControllerIndex == viewControllerList.count - 1) {
                return viewControllerList.first
            } else {
                return nil
            }
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else {
            return nil
        }
        
        switch scrollDirection {
        case .reverse:
            // To scroll the views from right to left
            if (viewControllerIndex < viewControllerList.count - 1) {
                return nil
            } else {
                return viewControllerList.first
            }
        default:
            // To scroll the views from left to right
            if (viewControllerIndex < viewControllerList.count - 1) {
                return viewControllerList.last
            } else {
                return nil
            }
            
        }
        
    }
    
}

extension HomeViewController: TopicFilterModelViewNavigation {
    func didTapDiscourseCategory(discourseCategory: DiscourseCategory) {
        topicFilterName = "#\(discourseCategory.name)"
        
        scrollToFirstViewController()
    }
    
    func didTapTopicFilter(topicFilter: TopicFilterType) {
        topicFilterName = topicFilter.rawValue
        homeDelegate?.topicFilterSelected(topicFilter: topicFilter)
        scrollToFirstViewController()
    }
    
}

extension HomeViewController: MainViewControllerProtocol {
    func resetHomePage() {
        scrollToFirstViewController()
        homeDelegate?.scrollToFirstRow()
    }
}

extension HomeViewController: TopicSearchViewControllerNavigationProtocol {
    func navigateToPostList(topicId: Int) {
        homeDelegate?.navigateToPostsList(topicId: topicId)
    }
}

// MARK: - Protocol HomeViewControllerDelegate definition
// To communicate with TopicListViewController
protocol HomeViewControllerDelegate: class {
    func topicFilterSelected(topicFilter: TopicFilterType)
    func navigateToPostsList(topicId: Int)
    func scrollToFirstRow()
}
