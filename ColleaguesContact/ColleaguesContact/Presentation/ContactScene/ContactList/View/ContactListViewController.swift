//
//  ContactListViewController.swift
//  ColleaguesContact
//
//  Created by Willy on 11/10/2022.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit

class ContactListViewController: UIViewController, StoryboardInstantiable, Alertable {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private var contactListContainer: UIView!
    @IBOutlet private(set) var suggestionsListContainer: UIView!
    @IBOutlet private var searchBarContainer: UIView!
    @IBOutlet private var emptyDataLabel: UILabel!
    
    private var viewModel: ContactListViewModel!
    private var contactTableViewController: ContactListTableViewController?
    private var searchController = UISearchController(searchResultsController: nil)
    
    class func create(with viewModel: ContactListViewModel) -> ContactListViewController {
        let vc = ContactListViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBehaviours()
        bind(to: viewModel)
        viewModel.requestApi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.isActive = false
    }
    
    func bind(to viewModel: ContactListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.updateItems() }
        viewModel.loading.observe(on: self) { [weak self] in self?.updateLoading($0) }
        viewModel.query.observe(on: self) { [weak self] in self?.updateSearchQuery($0) }
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == String(describing: ContactListTableViewController.self),
            let destinationVC = segue.destination as? ContactListTableViewController {
            contactTableViewController = destinationVC
            contactTableViewController?.viewModel = viewModel
        }
    }
    
    // MARK: - Private
    private func setupViews() {
        title = viewModel.screenTitle
        emptyDataLabel.text = viewModel.emptyDataTitle
        setupSearchController()
    }
    
    private func updateItems() {
        contactTableViewController?.reload()
    }
    
    private func updateLoading(_ loading: ContactListViewModelLoading?) {
        emptyDataLabel.isHidden = true
        contactListContainer.isHidden = true
        suggestionsListContainer.isHidden = true
        

        switch loading {
        case .loading:
            LoadingView.show()
        case .success:
            contactListContainer.isHidden = false
            LoadingView.hide()
            emptyDataLabel.isHidden = !viewModel.isEmpty
        case .empty:
            emptyDataLabel.isHidden = false
        case .none:
            contactListContainer.isHidden = viewModel.isEmpty
            emptyDataLabel.isHidden = !viewModel.isEmpty
        }

        updateQueriesSuggestions()
    }
    
    private func setupBehaviours() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
    
    private func updateQueriesSuggestions() {
        guard searchController.searchBar.isFirstResponder else {
            viewModel.closeQueriesSuggestions()
            return
        }
        viewModel.showQueriesSuggestions()
    }
    
    private func updateSearchQuery(_ query: String) {
        searchController.isActive = false
        searchController.searchBar.text = query
    }

    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        showAlert(title: viewModel.errorTitle, message: error)
    }
}

// MARK: - Search Controller

extension ContactListViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.searchBar.barStyle = .black
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
        definesPresentationContext = true
        if #available(iOS 13.0, *) {
            searchController.searchBar.searchTextField.accessibilityIdentifier = AccessibilityIdentifier.searchField
        }
    }
}

extension ContactListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension ContactListViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
        updateQueriesSuggestions()
    }
}
