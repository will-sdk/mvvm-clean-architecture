//
//  ContactQueriesTableViewViewController.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//  Copyright (c) 2022 All rights reserved.
//

import UIKit

final class ContactQueriesTableViewController: UITableViewController, StoryboardInstantiable {
    
    var viewModel: ContactQueriesListViewModel!
    
    class func create(with viewModel: ContactQueriesListViewModel) -> ContactQueriesTableViewController {
        let vc = ContactQueriesTableViewController.instantiateViewController()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        viewModel.viewWillAppear()
    }
    
    // MARK: - Private

    private func bind(to viewModel: ContactQueriesListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.tableView.reloadData() }
    }
    
    private func setupViews() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = ContactQueriesItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ContactQueriesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactQueriesItemCell.reuseIdentifier, for: indexPath) as? ContactQueriesItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(ContactQueriesItemCell.self) with reuseIdentifier: \(ContactQueriesItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        cell.fill(with: viewModel.items.value[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelect(item: viewModel.items.value[indexPath.row])
    }
}
