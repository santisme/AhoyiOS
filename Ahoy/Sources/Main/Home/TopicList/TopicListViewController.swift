//
//  TopicListViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class TopicListViewController: UIViewController, AhoyBannerProtocol {

    // MARK: - Private Properties
    lazy private var delegate: TopicListViewControllerDelegate? = {
       TopicListModelView(view: self, topicRepository: LocalRepository())
    }()
    private var topicFilterName: TopicFilterType = TopicFilterType.latest
    private var moreTopicsUrl: String? = nil
    private let pagingCellMargin: Int = 8
    private var model: [TopicCellModel]? = nil

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false

    }
    
    // MARK: - Actions
    @IBAction func newTopicClicked(_ sender: UIButton) {
        delegate?.newTopicClicked()
    }
    
    // MARK: - Private Methods
    private func setupView() {

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
        let cellNib = UINib(nibName: "TopicCell", bundle: Bundle(for: TopicCell.self))
        tableView.register(cellNib, forCellReuseIdentifier: TopicCell.identifier)
        configureRefreshControl()
       
        delegate?.viewDidLoad(topicFilterName: topicFilterName)
    }

    @objc
    private func searchClicked() {
        
    }
}

extension TopicListViewController {
    private func configureRefreshControl() {
        self.tableView?.refreshControl = UIRefreshControl(frame: self.tableView.frame)
        self.tableView?.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
    }
    
    @objc func handleRefreshControl() {
        // Update your content…
        delegate?.refreshTopicList(topicFilterName: topicFilterName)
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension TopicListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if let topicId = model?[indexPath.row].id {
            delegate?.didSelectTopic(topicId: topicId)
        }
    }
}

extension TopicListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell ?? TopicCell(style: .default, reuseIdentifier: TopicCell.identifier)
        
        guard let topic = model?[indexPath.row],
        let topicsCount = model?.count else {
            return cell
        }
        
        // Check if next page of topics is required
        if (topicFilterName != .top) {
            if ((topicsCount - indexPath.row) == pagingCellMargin) && (moreTopicsUrl != nil) {
                delegate?.requestTopics(topicFilter: topicFilterName, moreTopicsUrl: moreTopicsUrl)
            }
        }
        
        cell.userAvatar.image = topic.userImage ?? UIImage(named: "ahoyUserAvatarPlaceholder")
        cell.topicTitleLabel.text = topic.topicTitle
        cell.postCountLabel.text = "\(topic.postsCount)"
        cell.viewCountLabel.text = "\(topic.viewCount)"
        let createdAt = TimeOffsetRepository.factory.getTimeOffset(dateToCompareString: topic.createdAt)
        cell.createdAtLabel.text = (createdAt.amount > 1) ? "\(createdAt.amount) \(createdAt.unit)s" : "\(createdAt.amount) \(createdAt.unit)"
                
        return cell
    }
    
    
}

extension TopicListViewController: TopicListModelViewDelegate {
    func getCurrentModel() -> [TopicCellModel]? {
        return model
    }
    
    func updateUserAvatar(userAvatar: UIImage, indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TopicCell
        DispatchQueue.main.async {
            cell.userAvatar.image = userAvatar
            cell.setNeedsLayout()
        }
    }
    
    func showError(message: String) {
        // Due NotificationBanner pod behavior, It's important to delay one secons to show any banner
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            self?.showErrorBanner(message: message)
        }
    }
    
    func navigateToPostList(topicId: Int) {
        let postListViewController = PostListViewController(topicId: topicId)
        navigationController?.pushViewController(postListViewController, animated: true)
    }

    func updateModel(model: [TopicCellModel], moreTopicsUrl: String?) {
        self.model = model
        self.moreTopicsUrl = moreTopicsUrl
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
     }

    func clearTableView() {
        updateModel(model: [], moreTopicsUrl: nil)
    }
    
    func updateTopicFilterName(topicFilterName: TopicFilterType) {
        self.topicFilterName = topicFilterName
    }

    func navigateToNewTopic() {
        let newTopicViewController = NewTopicViewController()
        newTopicViewController.modalPresentationStyle = .pageSheet
        present(newTopicViewController, animated: true, completion: nil)
    }
}

// MARK: - Extension HomeViewControllerDelegate protocol implementation
extension TopicListViewController: HomeViewControllerDelegate {
    func navigateToPostsList(topicId: Int) {
        navigateToPostList(topicId: topicId)
    }
    
    func topicFilterSelected(topicFilter: TopicFilterType) {
        delegate?.topicFilterSelected(topicFilter: topicFilter)
    }
    
    func scrollToFirstRow() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

// MARK: - Protocol TopicListViewControllerDelegate definition
protocol TopicListViewControllerDelegate: class {
    func viewDidLoad(topicFilterName: TopicFilterType)
    func requestTopics(topicFilter: TopicFilterType, moreTopicsUrl: String?)
    func fetchUserAvatar(avatarTemplate: String?, completion: @escaping ((Result<UIImage, Error>) -> ()))
    func didSelectTopic(topicId: Int)
    func topicFilterSelected(topicFilter: TopicFilterType)
    func refreshTopicList(topicFilterName: TopicFilterType)
    func newTopicClicked()
}
