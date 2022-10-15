//
//  ContactSceneDIContainer.swift
//  ColleaguesContact
//
//  Created by Willy on 11/10/2022.
//

import UIKit

final class ContactSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    lazy var contactQueriesStorage: ContactQueriesStorage = CoreDataContactQueriesStorage(maxStorageLimit: 10)
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeSearchContactUseCase() -> SearchContactUseCase {
        return DefaultSearchContactUseCase(contactRepository: makeContactRepository(),
                                          contactQueriesRepository: makeContactQueriesRepository())
    }
    
    func makeFetchRecentContactQueriesUseCase(requestValue: FetchRecentContactQueriesUseCase.RequestValue,
                                            completion: @escaping (FetchRecentContactQueriesUseCase.ResultValue) -> Void) -> UseCase {
        return FetchRecentContactQueriesUseCase(requestValue: requestValue,
                                              completion: completion,
                                              contactQueriesRepository: makeContactQueriesRepository()
        )
    }
    
    // MARK: - Repositories
    func makeContactRepository() -> ContactRepository {
        return DefaultContactRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    func makeContactQueriesRepository() -> ContactQueriesRepository {
        return DefaultContactQueriesRepository(dataTransferService: dependencies.apiDataTransferService,
                                              contactQueriesPersistentStorage: contactQueriesStorage)
    }
    
    // MARK: - Contact List
    func makeContactListViewController(actions: ContactListViewModelActions) -> ContactListViewController {
        return ContactListViewController.create(with: makeContactListViewModel(actions: actions))
    }
    
    func makeContactListViewModel(actions: ContactListViewModelActions) -> ContactListViewModel {
        return DefaultContactListViewModel(searchContactUseCase: makeSearchContactUseCase(),
                                          actions: actions)
    }
    
    // MARK: - Contact Details
    func makeContactDetailsViewController(contact: Contact) -> UIViewController {
        return ContactDetailsViewController.create(with: makeContactDetailsViewModel(contact: contact))
    }
    
    func makeContactDetailsViewModel(contact: Contact) -> ContactDetailsViewModel {
        return DefaultContactDetailsViewModel(contact: contact)
    }
    
    // MARK: - Contact Queries Suggestions List
    func makeContactQueriesSuggestionsListViewController(didSelect: @escaping ContactQueryListViewModelDidSelectAction) -> UIViewController {
        return ContactQueriesTableViewController.create(with: makeContactQueryListViewModel(didSelect: didSelect))
    }
    
    func makeContactQueryListViewModel(didSelect: @escaping ContactQueryListViewModelDidSelectAction) -> ContactQueriesListViewModel {
        return DefaultContactQueriesListViewModel(numberOfQueriesToShow: 10,
                                               fetchRecentContactQueriesUseCaseFactory: makeFetchRecentContactQueriesUseCase,
                                               didSelect: didSelect)
    }
    
    // MARK: - Flow Coordinators
    func makeContactSearchFlowCoordinator(navigationController: UINavigationController) -> ContactSearchFlowCoordinator {
        return ContactSearchFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }

}

extension ContactSceneDIContainer: ContactSearchFlowCoordinatorDependencies {}
