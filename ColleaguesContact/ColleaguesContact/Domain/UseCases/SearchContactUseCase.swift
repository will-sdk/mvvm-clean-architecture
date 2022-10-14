//
//  SearchContactUseCase.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

protocol SearchContactUseCase {
    func execute(requestValue: SearchContactUseCaseRequestValue,
                 completion: @escaping (Result<ContactData, Error>) -> Void) -> Cancellable?
}

final class DefaultSearchContactUseCase: SearchContactUseCase {
    
    private let contactRepository: ContactRepository
    private let contactQueriesRepository: ContactQueriesRepository

    init(contactRepository: ContactRepository,
         contactQueriesRepository: ContactQueriesRepository) {

        self.contactRepository = contactRepository
        self.contactQueriesRepository = contactQueriesRepository
    }

    func execute(requestValue: SearchContactUseCaseRequestValue,
                 completion: @escaping (Result<ContactData, Error>) -> Void) -> Cancellable? {

        return contactRepository.fetchContactList(query: requestValue.query,
                                                completion: { result in

            if case .success = result {
                self.contactQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
            }

            completion(result)
        })
    }
}

struct SearchContactUseCaseRequestValue {
    let query: ContactQuery
}

