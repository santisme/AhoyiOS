//
//  PostListViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 15/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

final class PostListViewController: UIViewController, AhoyBannerProtocol {
    // MARK: - Private Properties
    lazy private var delegate: PostListViewControllerDelegate? = {
        PostListModelView(view: self, postRepository: LocalRepository(), topicId: topicId)
    }()
    private var model: [PostCellModel]? = nil
    private var headerModel: PostListHeaderCellModel? = nil
    private let topicId: Int
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
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
    
    // MARK: - Private Methods
    private func setupView() {
        
        let postCell = UINib(nibName: "PostCell", bundle: Bundle(for: PostCell.self))
        tableView.register(postCell, forCellReuseIdentifier: PostCell.identifier)
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        configureRefreshControl()
        setupTableHeader()
        
        delegate?.viewDidLoad()
    }
    
    private func setupTableHeader() {
        
        // Registed Header Cell
        let headerCellNib = UINib(nibName: PostListHeaderCell.identifier, bundle: Bundle(for: PostListHeaderCell.self))
        self.tableView.register(headerCellNib, forCellReuseIdentifier: PostListHeaderCell.identifier)
        
        let headerCell = self.tableView.dequeueReusableCell(withIdentifier: PostListHeaderCell.identifier) as? PostListHeaderCell ?? PostListHeaderCell()
        
        headerCell.delegate = self
        self.tableView.tableHeaderView = headerCell
    }
}

extension PostListViewController {
    private func configureRefreshControl() {
        self.tableView?.refreshControl = UIRefreshControl(frame: self.tableView.frame)
        self.tableView?.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
    }
    
    @objc func handleRefreshControl() {
        // Update your content…
        delegate?.refreshPostList()
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Extension UITable
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.identifier, for: indexPath) as? PostCell ?? PostCell(style: .default, reuseIdentifier: PostCell.identifier)
        
        guard let modelEntry = model?[indexPath.row] else {
            return PostCell()
        }
        
        cell.avatarImage.image = modelEntry.userImage ?? UIImage(named: "ahoyUserAvatarPlaceholder")
        
        cell.usernameLabel.text = modelEntry.username

        if let postContent = delegate?.htmlToAttributedText(html: modelEntry.postContent) {
            cell.postLabel.text = postContent.string
//            cell.postLabel.attributedText = postContent
        } else {
            cell.postLabel.text = modelEntry.postContent
        }
                
        let updatedAt = TimeOffsetRepository.factory.getTimeOffset(dateToCompareString: modelEntry.updatedAt)
        cell.updatedAtLabel.text = (updatedAt.amount > 1) ? "\(updatedAt.amount) \(updatedAt.unit)s" : "\(updatedAt.amount) \(updatedAt.unit)"
        
        return cell
        
    }

}

// MARK: - Protocol PostListModelViewProtocol implementation
extension PostListViewController: PostListModelViewProtocol {

    func updateModel(model: [PostCellModel]) {
        self.model = model
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func updateHeaderModel(headerModel: PostListHeaderCellModel) {
        self.headerModel = headerModel
        
        DispatchQueue.main.async { [weak self] in
            let headerCell = self?.tableView.dequeueReusableCell(withIdentifier: PostListHeaderCell.identifier) as? PostListHeaderCell ?? PostListHeaderCell()

            headerCell.delegate = self
            headerCell.fillOutUI(model: headerModel)
            self?.tableView.tableHeaderView = headerCell
        }
    }
    
    func showError(message: String) {
        showErrorBanner(message: message)
    }
    
    func navigateToNewPost() {
        let newPostViewController = NewPostViewController(topicId: topicId)
        newPostViewController.modalPresentationStyle = .pageSheet
        present(newPostViewController, animated: true, completion: nil)
    }
    
}

extension PostListViewController: PostListHeaderCellDelegate {
    func answerClicked() {
        delegate?.answerClicked()
    }
    
}

// MARK: - Protocol PostListViewControllerDelegate definition
protocol PostListViewControllerDelegate: class {
    func viewDidLoad()
    func refreshPostList()
    func requestPostList()
    func htmlToAttributedText(html: String) -> NSAttributedString?
    func answerClicked()
}

protocol PostListHeaderCellProtocol {
    func fillOutUI(model: PostListHeaderCellModel)
}
