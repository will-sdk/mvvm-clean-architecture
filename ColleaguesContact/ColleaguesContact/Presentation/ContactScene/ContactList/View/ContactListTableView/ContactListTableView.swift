//
//  ContactListTableView.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import UIKit

final class ContactListTableViewController: UITableViewController {

    var viewModel: ContactListViewModel!

    var posterImagesRepository: PosterImagesRepository?
    var nextPageLoadingSpinner: UIActivityIndicatorView?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func reload() {
        tableView.reloadData()
    }

    // MARK: - Private

    private func setupViews() {
        tableView.estimatedRowHeight = ContactListItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ContactListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactListItemCell.reuseIdentifier,
                                                       for: indexPath) as? ContactListItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(ContactListItemCell.self) with reuseIdentifier: \(ContactListItemCell.reuseIdentifier)")
            return UITableViewCell()
        }

        cell.fill(with: viewModel.items.value[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
