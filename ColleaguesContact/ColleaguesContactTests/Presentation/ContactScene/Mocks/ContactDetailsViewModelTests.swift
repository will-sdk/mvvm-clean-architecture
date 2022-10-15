//
//  ContactDetailsViewModelTests.swift
//  ColleaguesContactTests
//
//  Created by Willy on 15/10/2022.
//

import XCTest

class ContactDetailsViewModelTests: XCTestCase {
    
    private enum PosterImageDowloadError: Error {
        case someError
    }
    
    func test_dataContactDetailsViewModelTests() {
        // given
        let viewModel = DefaultContactDetailsViewModel(contact: Contact.stub(firstName: "Owen", lastName: "Mike"))
        
        
        // when
        
        // then
        XCTAssertEqual(viewModel.title, "Owen")
    }
}
