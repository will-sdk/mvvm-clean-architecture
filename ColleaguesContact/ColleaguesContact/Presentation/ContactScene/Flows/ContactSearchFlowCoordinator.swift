//
//  ContactSearchFlowCoordinator.swift
//  ColleaguesContact
//
//  Created by Willy on 11/10/2022.
//

import UIKit

protocol ContactSearchFlowCoordinatorDependencies  {
    func makeContactListViewController(actions: ContactListViewModelActions) -> ContactListViewController
    func makeContactDetailsViewController(contact: Contact) -> UIViewController
    func makeContactQueriesSuggestionsListViewController(didSelect: @escaping ContactQueryListViewModelDidSelectAction) -> UIViewController
}

final class ContactSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: ContactSearchFlowCoordinatorDependencies

    private weak var contactListVC: ContactListViewController?
    private weak var contactQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: ContactSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = ContactListViewModelActions(showContactDetails: showContactDetails,
                                                 showContactQueriesSuggestions: showContactQueriesSuggestions,
                                                 closeContactQueriesSuggestions: closeContactQueriesSuggestions)
        let vc = dependencies.makeContactListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
        contactListVC = vc
       
    }
    
    private func showContactDetails(contact: Contact) {
        let vc = dependencies.makeContactDetailsViewController(contact: contact)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func showContactQueriesSuggestions(didSelect: @escaping (ContactQuery) -> Void) {
        guard let contactListViewController = contactListVC, contactQueriesSuggestionsVC == nil,
            let container = contactListViewController.suggestionsListContainer else { return }

        let vc = dependencies.makeContactQueriesSuggestionsListViewController(didSelect: didSelect)

        contactListViewController.add(child: vc, container: container)
        contactQueriesSuggestionsVC = vc
        container.isHidden = false
    }

    private func closeContactQueriesSuggestions() {
        contactQueriesSuggestionsVC?.remove()
        contactQueriesSuggestionsVC = nil
        contactListVC?.suggestionsListContainer.isHidden = true
    }
}
