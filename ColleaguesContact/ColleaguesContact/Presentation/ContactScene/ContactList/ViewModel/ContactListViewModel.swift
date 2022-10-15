//
//  ContactListViewModel.swift
//  ColleaguesContact
//
//  Created by Willy on 11/10/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation

struct ContactListViewModelActions {
    let showContactDetails: (Contact) -> Void
    let showContactQueriesSuggestions: (@escaping (_ didSelect: ContactQuery) -> Void) -> Void
    let closeContactQueriesSuggestions: () -> Void
}

enum ContactListViewModelLoading {
    case loading
    case success
    case empty
}

protocol ContactListViewModelInput {
    func viewDidLoad()
    func requestApi()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
}

protocol ContactListViewModelOutput {
    var items: Observable<[ContactListItemViewModel]> { get }
    var loading: Observable<ContactListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol ContactListViewModel: ContactListViewModelInput, ContactListViewModelOutput { }

final class DefaultContactListViewModel: ContactListViewModel {
    
    private let searchContactUseCase: SearchContactUseCase
    private let actions: ContactListViewModelActions?
    
    private var contact: [Contact] = []
    private var contactLoadTask: Cancellable? { willSet { contactLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    let items: Observable<[ContactListItemViewModel]> = Observable([])
    let loading: Observable<ContactListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = "Contact"
    let emptyDataTitle = "Empty Data!!"
    let errorTitle = "Error"
    let searchBarPlaceholder = "Search"
    
    // MARK: - Init

    init(searchContactUseCase: SearchContactUseCase,
         actions: ContactListViewModelActions? = nil) {
        self.searchContactUseCase = searchContactUseCase
        self.actions = actions
    }
    
    // MARK: - Private
    
    private func load(contactQuery: ContactQuery) {
        loading.value = .empty
        self.loading.value = .loading
        query.value = contactQuery.query
        
        contactLoadTask = searchContactUseCase.execute(
            requestValue: .init(query: contactQuery),
            completion: { result in
                switch result {
                case .success(let resp):
                    self.loading.value = .success
                    self.appendPage(resp)
                case .failure(let error):
                    self.loading.value = .empty
                    self.handle(error: error)
                }
        })
    }
    
    private func appendPage(_ contactData: ContactData) {
        contact = contactData.contact
        items.value = contact.map(ContactListItemViewModel.init)
    }
    
    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("Failed loading contact", comment: "")
    }
    
    private func update(contactQuery: ContactQuery) {
        resetPages()
        load(contactQuery: contactQuery)
    }
    
    private func resetPages() {
        items.value.removeAll()
    }
}

// MARK: - INPUT. View event methods
extension DefaultContactListViewModel {
    func viewDidLoad() {
        
    }
    
    func requestApi() {
        load(contactQuery: .init(query: ""))
    }
    
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(contactQuery: ContactQuery(query: query))
    }

    func didCancelSearch() {
        contactLoadTask?.cancel()
    }

    func showQueriesSuggestions() {
        actions?.showContactQueriesSuggestions(update(contactQuery:))
    }

    func closeQueriesSuggestions() {
        actions?.closeContactQueriesSuggestions()
    }

    func didSelectItem(at index: Int) {
        actions?.showContactDetails(contact[index])
    }
}

// MARK: - Private

private extension Array where Element == ContactData {
    var contact: [Contact] { flatMap { $0.contact } }
}
