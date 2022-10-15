//
//  ContactQueriesListViewModel.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation

typealias ContactQueryListViewModelDidSelectAction = (ContactQuery) -> Void

protocol ContactQueriesListViewModelInput {
    func viewWillAppear()
    func didSelect(item: ContactQueryListItemViewModel)
}

protocol ContactQueriesListViewModelOutput {
    var items: Observable<[ContactQueryListItemViewModel]> { get }
}

protocol ContactQueriesListViewModel: ContactQueriesListViewModelInput, ContactQueriesListViewModelOutput { }

typealias FetchRecentContactQueriesUseCaseFactory = (
    FetchRecentContactQueriesUseCase.RequestValue,
    @escaping (FetchRecentContactQueriesUseCase.ResultValue) -> Void
    ) -> UseCase

class DefaultContactQueriesListViewModel: ContactQueriesListViewModel {
    
    private let numberOfQueriesToShow: Int
    private let fetchRecentContactQueriesUseCaseFactory: FetchRecentContactQueriesUseCaseFactory
    private let didSelect: ContactQueryListViewModelDidSelectAction?
    
    // MARK: - OUTPUT
    let items: Observable<[ContactQueryListItemViewModel]> = Observable([])
    
    init(numberOfQueriesToShow: Int,
         fetchRecentContactQueriesUseCaseFactory: @escaping FetchRecentContactQueriesUseCaseFactory,
         didSelect: ContactQueryListViewModelDidSelectAction? = nil) {
        self.numberOfQueriesToShow = numberOfQueriesToShow
        self.fetchRecentContactQueriesUseCaseFactory = fetchRecentContactQueriesUseCaseFactory
        self.didSelect = didSelect
    }
    
    private func updateContactQueries() {
        let request = FetchRecentContactQueriesUseCase.RequestValue(maxCount: numberOfQueriesToShow)
        let completion: (FetchRecentContactQueriesUseCase.ResultValue) -> Void = { result in
            switch result {
            case .success(let items):
                let itemsFilter = items.filter( { !$0.query.isEmpty })
                self.items.value = itemsFilter.map { $0.query }.map(ContactQueryListItemViewModel.init)
            case .failure: break
            }
        }
        let useCase = fetchRecentContactQueriesUseCaseFactory(request, completion)
        useCase.start()
    }
}

// MARK: - INPUT. View event methods
extension DefaultContactQueriesListViewModel {
        
    func viewWillAppear() {
        updateContactQueries()
    }
    
    func didSelect(item: ContactQueryListItemViewModel) {
        didSelect?(ContactQuery(query: item.query))
    }
}
