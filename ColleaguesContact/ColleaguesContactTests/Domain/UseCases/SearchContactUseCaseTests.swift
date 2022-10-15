//
//  SearchContactUseCaseTests.swift
//  ColleaguesContactTests
//
//  Created by Willy on 15/10/2022.
//

import XCTest

class SearchContactUseCaseTests: XCTestCase {
    
    static let contact: ContactData = {
        let contact1 = Contact.stub(id: "1",
                         firstName: "Maggie" ,
                         lastName: "Brekke",
                         email: "Crystel.Nicolas61@hotmail.com",
                         jobtitle: "Future Functionality Strategist",
                         favouriteColor: "pink",
                         avatar: "https://randomuser.me/api/portraits/women/IsaryAmairani_128.jpg"
                         )
        let contact2 = Contact.stub(id: "2",
                         firstName: "Gunnar" ,
                         lastName: "Gibson",
                         email: "Paolo.Hudson@yahoo.com",
                         jobtitle: "Senior Directives Officer",
                         favouriteColor: "indigo",
                         avatar: "https://randomuser.me/api/portraits/women/4.jpg"
                         )
        return ContactData.init(contact: [contact1, contact2])
    }()
    
    enum ContactRepositorySuccessTestError: Error {
        case failedFetching
    }
    
    class ContactQueriesRepositoryMock: ContactQueriesRepository {
        var recentQueries: [ContactQuery] = []
        
        func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ContactQuery], Error>) -> Void) {
            completion(.success(recentQueries))
        }
        func saveRecentQuery(query: ContactQuery, completion: @escaping (Result<ContactQuery, Error>) -> Void) {
            recentQueries.append(query)
        }
    }
    
    struct ContactRepositoryMock: ContactRepository {
        var result: Result<ContactData, Error>
        func fetchContactList(query: ContactQuery, completion: @escaping (Result<ContactData, Error>) -> Void) -> Cancellable? {
            completion(result)
            return nil
        }
    }
    
    func testSearchContactUseCase_whenSuccessfullyFetchesContactForQuery_thenQueryIsSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Recent query saved")
        expectation.expectedFulfillmentCount = 2
        let contactQueriesRepository = ContactQueriesRepositoryMock()
        let useCase = DefaultSearchContactUseCase(contactRepository: ContactRepositoryMock(result: .success(SearchContactUseCaseTests.contact)),
                                                  contactQueriesRepository: contactQueriesRepository)

        // when
        let requestValue = SearchContactUseCaseRequestValue(query: ContactQuery(query: "title1"))
        _ = useCase.execute(requestValue: requestValue, completion: { _ in
            expectation.fulfill()
        })
        
        // then
        var recents = [ContactQuery]()
        contactQueriesRepository.fetchRecentsQueries(maxCount: 1) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(recents.contains(ContactQuery(query: "title1")))
    }
    
    func testSearchContactUseCase_whenFailedFetchingContactForQuery_thenQueryIsNotSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Recent query should not be saved")
        expectation.expectedFulfillmentCount = 2
        let contactQueriesRepository = ContactQueriesRepositoryMock()
        let useCase = DefaultSearchContactUseCase(contactRepository: ContactRepositoryMock(result: .failure(ContactRepositorySuccessTestError.failedFetching)),
                                                  contactQueriesRepository: contactQueriesRepository)
        
        // when
        let requestValue = SearchContactUseCaseRequestValue(query: ContactQuery(query: "title1"))
        _ = useCase.execute(requestValue: requestValue, completion: { _ in
            expectation.fulfill()
        })
      
        // then
        var recents = [ContactQuery]()
        contactQueriesRepository.fetchRecentsQueries(maxCount: 1) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(recents.isEmpty)
    }
}
