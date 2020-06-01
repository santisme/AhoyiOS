//
//  TopicFilterViewController.swift
//  Ahoy
//
//  Created by Santiago Sanchez merino on 03/03/2020.
//  Copyright © 2020 Santiago Sanchez Merino. All rights reserved.
//

import UIKit

enum TopicFilterType: String {
    case top = "Top topics"
    case latest = "Latest topics"
}

final class TopicFilterViewController: UIViewController, AhoyBannerProtocol {
    // MARK: - Private Properties
    private var discourseCategoryList: [DiscourseCategory] = []
    private var topicFilterList: [TopicFilterType] = [ TopicFilterType.top, TopicFilterType.latest ]
    private var delegate: TopicFilterViewControllerDelegate? = nil
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Inits
    init(navigation: TopicFilterModelViewNavigation) {
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        delegate = TopicFilterModelView(view: self, navigation: navigation, localRepository: LocalRepository())
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
        navigationController?.isNavigationBarHidden = true

    }
    
    // MARK: - Private Methods
    private func setupView() {
        setupTableHeader()

        // Register custom cell to use
        let cellNib = UINib(nibName: TopicFilterCell.identifier, bundle: Bundle(for: TopicFilterCell.self))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(cellNib, forCellReuseIdentifier: TopicFilterCell.identifier)
        
        // Request Discourse Category List to delegate
        delegate?.viewDidLoad()
        configureRefreshControl()
        
    }
    
        private func setupTableHeader() {
            // Registed Header Cell
            let headerCellNib = UINib(nibName: TopicFilterHeaderCell.identifier, bundle: Bundle(for: PostListHeaderCell.self))
            self.tableView.register(headerCellNib, forCellReuseIdentifier: TopicFilterHeaderCell.identifier)
            
            let headerCell = self.tableView.dequeueReusableCell(withIdentifier: TopicFilterHeaderCell.identifier) as? TopicFilterHeaderCell ?? TopicFilterHeaderCell()
            
            self.tableView.tableHeaderView = headerCell
    //        self.tableView.tableHeaderView?.setNeedsLayout()
        }
}

extension TopicFilterViewController {
    private func configureRefreshControl() {
        self.tableView?.refreshControl = UIRefreshControl(frame: self.tableView.frame)
        self.tableView?.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        
    }
    
    @objc func handleRefreshControl() {
        // Update your content…
        delegate?.refreshDiscourseCategoryList()
        
        // Dismiss the refresh control.
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

// MARK: - Extension UITableViewDelegate implementation
extension TopicFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.section {
        case 0:
            delegate?.didTapDiscourseCategory(discourseCategory: self.discourseCategoryList[indexPath.row])

        case 1:
            delegate?.didTapTopicFilter(topicFilter: self.topicFilterList[indexPath.row])

        default:
            break
        }
    }
}

// MARK: - Extension UITableViewDataSource implementation
extension TopicFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? discourseCategoryList.count : topicFilterList.count
    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Categories" : "Default filters" 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: TopicFilterCell.identifier, for: indexPath) as? TopicFilterCell ?? TopicFilterCell(style: .default, reuseIdentifier: TopicFilterCell.identifier)
        
        switch indexPath.section {
        case 0:
            cell.topicFilterLabel.text = "#\(discourseCategoryList[indexPath.row].name)"
        case 1:
            cell.topicFilterLabel.text = "\(topicFilterList[indexPath.row].rawValue)"
        default:
            break
        }
        return cell

    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.tintColor = AhoyUIResources.factory.color(usage: .ahoyMainBackgroundColor)
        headerView.textLabel?.font = AhoyUIResources.factory.font(style: .body18bold)
    }
}

extension TopicFilterViewController: TopicFilterModelViewProtocol {
    func updateDiscourseCategoryList(discourseCategoryList: [DiscourseCategory]) {
        self.discourseCategoryList = discourseCategoryList
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showError(message: String) {
        showErrorBanner(message: message)
    }
    
}

protocol TopicFilterViewControllerDelegate:class {
    func viewDidLoad()
    func didTapDiscourseCategory(discourseCategory: DiscourseCategory)
    func didTapTopicFilter(topicFilter: TopicFilterType)
    func refreshDiscourseCategoryList()
}
