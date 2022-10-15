//
//  ContactListViewModelTests.swift
//  ColleaguesContactTests
//
//  Created by Willy on 15/10/2022.
//

import XCTest

class ContactListViewModelTests: XCTestCase {
    
    private enum SearchContactUseCaseError: Error {
        case someError
    }
    
    
    let contact: ContactData = {
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
    
    class SearchContactUseCaseMock: SearchContactUseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var contactData = ContactData(contact: [])
        
        func execute(requestValue: SearchContactUseCaseRequestValue,
                     completion: @escaping (Result<ContactData, Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(contactData))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    func test_searchQueryViewModelContains() {
        // given
        let searchContactUseCaseMock = SearchContactUseCaseMock()
        searchContactUseCaseMock.contactData = ContactData(contact: contact.contact)
        let viewModel = DefaultContactListViewModel(searchContactUseCase: searchContactUseCaseMock)
        // when
        viewModel.didSearch(query: "search query")
        
        // then
        XCTAssertEqual(viewModel.searchTitle, "search query")
    }
    
    func test_whenSearchContactUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let searchContactUseCaseMock = SearchContactUseCaseMock()
        searchContactUseCaseMock.expectation = self.expectation(description: "contain errors")
        searchContactUseCaseMock.error = SearchContactUseCaseError.someError
        let viewModel = DefaultContactListViewModel(searchContactUseCase: searchContactUseCaseMock)
        // when
        viewModel.didSearch(query: "query")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(viewModel.error)
    }
    
}
