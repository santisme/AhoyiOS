//
//  TopicSearchViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 24/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class TopicSearchViewController: UIViewController, AhoyBannerProtocol {

    // MARK: - Private Properties
    private var topicListResponse: TopicListResponse? = nil
    private var topicCellModel: [TopicCellModel] = [TopicCellModel]()
    private var postCellModelWrapper: [PostCellModelWrapper] = [PostCellModelWrapper]()
    private var delegate: TopicSearchViewControllerDelegate? = nil
    private let navigation: TopicSearchViewControllerNavigationProtocol
    private var currentScopeItem: SearchScopeItem = .topics

    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Inits
    init(navigation: TopicSearchViewControllerNavigationProtocol) {
        self.navigation = navigation
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
        delegate = TopicSearchModelView(view: self, searchRepository: LocalRepository())
        
        let topicCellNib = UINib(nibName: TopicCell.identifier, bundle: Bundle(for: TopicCell.self))
        tableView.register(topicCellNib, forCellReuseIdentifier: TopicCell.identifier)

        let postCellNib = UINib(nibName: PostCell.identifier, bundle: Bundle(for: PostCell.self))
        tableView.register(postCellNib, forCellReuseIdentifier: PostCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        setupSearchBar()

        delegate?.viewDidLoad()
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search topics"
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.scopeButtonTitles = []
        searchBar.setShowsScope(true, animated: true)
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }
    
}

// MARK: - UISearchBarDelegate extension
extension TopicSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            delegate?.searchBarSearchButtonClicked(searchText: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        delegate?.selectedScopeButtonIndexDidChange(selectedScope: selectedScope)
    }
}

// MARK: - UISearchResultsUpdating protocol
//extension TopicSearchViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchBar.text, !searchText.isEmpty {
//            delegate?.updateSearchResults(searchText: searchText)
//        }
//    }
//
//}

extension TopicSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectRowAt(indexPath: indexPath)
    }
}

extension TopicSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentScopeItem {
        case .topics:
            return topicCellModel.count
        case .posts:
            return postCellModelWrapper.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentScopeItem {
        case .topics:
            let cell = tableView.dequeueReusableCell(withIdentifier: TopicCell.identifier, for: indexPath) as? TopicCell ?? TopicCell()
            let cellContent = topicCellModel[indexPath.row]
            cell.topicTitleLabel.text = cellContent.topicTitle
            cell.postCountLabel.text = "\(cellContent.postsCount)"
            cell.viewCountLabel.text = "\(cellContent.viewCount)"
            let createdAt = TimeOffsetRepository.factory.getTimeOffset(dateToCompareString: cellContent.createdAt)
            cell.createdAtLabel.text = (createdAt.amount > 1) ? "\(createdAt.amount) \(createdAt.unit)s" : "\(createdAt.amount) \(createdAt.unit)"
            return cell
        case .posts:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell ?? PostCell()
            let cellContent = postCellModelWrapper[indexPath.row]
            cell.avatarImage.image = cellContent.postCellModel.userImage
            cell.usernameLabel.text = cellContent.postCellModel.username
            cell.postLabel.text = cellContent.postCellModel.postContent
            let updatedAt = TimeOffsetRepository.factory.getTimeOffset(dateToCompareString: cellContent.postCellModel.updatedAt)
            cell.updatedAtLabel.text = (updatedAt.amount > 1) ? "\(updatedAt.amount) \(updatedAt.unit)s" : "\(updatedAt.amount) \(updatedAt.unit)"
            return cell
        }
    }
    

}

extension TopicSearchViewController: TopicSearchModelViewDelegate {

    func setScopeButtonTitles(searchScopeItems: [String]) {
        DispatchQueue.main.async { [weak self] in
            self?.searchBar.scopeButtonTitles = searchScopeItems
            self?.searchBar.selectedScopeButtonIndex = 0
        }
    }
    
    func updateSelectedScopeItem(scopeItem: SearchScopeItem) {
        self.currentScopeItem = scopeItem
    }
    
    func updateTopicCellModel(topicCellModel: [TopicCellModel]) {
        self.topicCellModel = topicCellModel
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func updatePostCellModelWrapper(postCellModelWrapper: [PostCellModelWrapper]) {
        self.postCellModelWrapper = postCellModelWrapper
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showError(message: String) {
        showErrorBanner(message: message)
    }
    
    func navigateToPostList(topicId: Int) {
        dismiss(animated: true) { [weak self] in
            self?.navigation.navigateToPostList(topicId: topicId)
        }
    }
    
}

protocol TopicSearchViewControllerDelegate: class {
    func viewDidLoad()
    func selectedScopeButtonIndexDidChange(selectedScope: Int)
    func searchBarSearchButtonClicked(searchText: String)
    func didSelectRowAt(indexPath: IndexPath)
}

protocol TopicSearchViewControllerNavigationProtocol: class {
    func navigateToPostList(topicId: Int)
}
