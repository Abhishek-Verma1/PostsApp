//
//  PostViewController.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit
import Combine
import Domain

#warning("Optimization is required in the next sprint.")
final class PostViewController: UIViewController {
    
    // MARK: - Private Properties
    @IBOutlet weak var noDataAvailableLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private lazy var dataSource = createDataSource()
    private let viewModel: PostListViewModel
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Init
    init?(coder: NSCoder, viewModel: PostListViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("viewModel(PostListViewModel) must provided while initialisation")
    }
    
    // MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataAvailableLabel.isHidden = true
        tableView.isHidden = true
        setupUI()
        bind()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        self.title = viewModel.title
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bind() {
        tableView.dataSource = dataSource
        self.viewModel.getAllPosts()
        self.showLoadingMask(isOverFullscreen: true)
        viewModel.stateDidUpdate.sink(receiveValue: { [weak self] state in
            DispatchQueue.main.async {
                self?.hideLoadingMask(completion: {
                    guard let self = self else { return }
                    self.renderViewModelState(state)
                })
            }
        }).store(in: &cancellable)
    }
    
    private func renderViewModelState(_ state: PostViewModelState) {
        switch state {
        case .error(let errorMessage):
            self.showData(isShowErrorLabel: true)
            updateTable(with: [], animate: false)
            showAlert(errorMessage)
        case .showRepositories(let repositories):
            self.showData(isShowErrorLabel: repositories.isEmpty)
            updateTable(with: repositories, animate: false)
        }
    }
    
    private func showData(isShowErrorLabel: Bool) {
        noDataAvailableLabel.isHidden = !isShowErrorLabel
        tableView.isHidden = isShowErrorLabel
    }
    
    @IBAction func segmentValueChange(_ sender: UISegmentedControl) {
        self.showData(isShowErrorLabel: true)
        viewModel.changePostShowState(onlyFavouritePost: sender.selectedSegmentIndex != 0)
    }
    @IBAction func logoutTapped(_ sender: Any) {
        viewModel.logout()
    }
}

// MARK: - Extension for Tableview datasource
fileprivate extension PostViewController {
    enum Section: CaseIterable {
        case Post
    }
    
    private func createDataSource() -> UITableViewDiffableDataSource<Section, Post> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, repoCellViewModel in
                let cell: PostListTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.configure(with: repoCellViewModel)
                cell.favoriteButton.addTarget(self, action: #selector(self.favoriteButtonTapped(sender:)), for: .touchUpInside)
                cell.favoriteButton.isSelected = repoCellViewModel.isFavourite ?? false
                return cell
            })
    }
    
    private func updateTable(with repositories: [Post], animate: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(repositories, toSection: .Post)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
    
    @objc func favoriteButtonTapped(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        viewModel.changeFavoriteStatus(id: sender.tag, isSelected: sender.isSelected)
    }
}

// MARK: - Extension for UITableViewDelegate
extension PostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Extension for UISearchBarDelegate
extension PostViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
