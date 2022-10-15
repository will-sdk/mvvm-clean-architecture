//
//  ContactQueriesListViewModelTests.swift
//  ColleaguesContactTests
//
//  Created by Willy on 15/10/2022.
//

@testable import ColleaguesContact
import XCTest

class ContactQueriesListViewModelTests: XCTestCase {
    
    private enum FetchRecentQueriedUseCase: Error {
        case someError
    }
    
    var contactQueries = [ContactQuery(query: "query1"),
                        ContactQuery(query: "query2"),
                        ContactQuery(query: "query3"),
                        ContactQuery(query: "query4"),
                        ContactQuery(query: "query5")]

    class FetchRecentContactQueriesUseCaseMock: UseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var contactQueries: [ContactQuery] = []
        var completion: (Result<[ContactQuery], Error>) -> Void = { _ in }

        func start() -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(contactQueries))
            }
            expectation?.fulfill()
            return nil
        }
    }

    func makeFetchRecentContactQueriesUseCase(_ mock: FetchRecentContactQueriesUseCaseMock) -> FetchRecentContactQueriesUseCaseFactory {
        return { _, completion in
            mock.completion = completion
            return mock
        }
    }
    
    
    func test_whenFetchRecentContactQueriesUseCaseReturnsQueries_thenShowTheseQueries() {
        // given
        let useCase = FetchRecentContactQueriesUseCaseMock()
        useCase.expectation = self.expectation(description: "Recent query fetched")
        useCase.contactQueries = contactQueries
        let viewModel = DefaultContactQueriesListViewModel(numberOfQueriesToShow: 3,
                                                        fetchRecentContactQueriesUseCaseFactory: makeFetchRecentContactQueriesUseCase(useCase))

        // when
        viewModel.viewWillAppear()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.items.value.map { $0.query }, contactQueries.map { $0.query })
    }
    
    func test_whenFetchRecentContactQueriesUseCaseReturnsError_thenDontShowAnyQuery() {
        // given
        let useCase = FetchRecentContactQueriesUseCaseMock()
        useCase.expectation = self.expectation(description: "Recent query fetched")
        useCase.error = FetchRecentQueriedUseCase.someError
        let viewModel = DefaultContactQueriesListViewModel(numberOfQueriesToShow: 3,
                                                        fetchRecentContactQueriesUseCaseFactory: makeFetchRecentContactQueriesUseCase(useCase))
        
        // when
        viewModel.viewWillAppear()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(viewModel.items.value.isEmpty)
    }
    
    func test_whenDidSelectQueryEventIsReceived_thenCallDidSelectAction() {
        // given
        let selectedQueryItem = ContactQuery(query: "query1")
        var actionContactQuery: ContactQuery?
        let expectation = self.expectation(description: "Delegate notified")
        let didSelect: ContactQueryListViewModelDidSelectAction = { contactQuery in
            actionContactQuery = contactQuery
            expectation.fulfill()
        }
        
        let viewModel = DefaultContactQueriesListViewModel(numberOfQueriesToShow: 3,
                                                        fetchRecentContactQueriesUseCaseFactory: makeFetchRecentContactQueriesUseCase(FetchRecentContactQueriesUseCaseMock()),
                                                        didSelect: didSelect)
        
        // when
        viewModel.didSelect(item: ContactQueryListItemViewModel(query: selectedQueryItem.query))
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actionContactQuery, selectedQueryItem)
    }
}
