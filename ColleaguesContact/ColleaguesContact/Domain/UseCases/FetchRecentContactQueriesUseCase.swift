//
//  FetchRecentContactQueriesUseCase.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

final class FetchRecentContactQueriesUseCase: UseCase {

    struct RequestValue {
        let maxCount: Int
    }
    typealias ResultValue = (Result<[ContactQuery], Error>)

    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    private let contactQueriesRepository: ContactQueriesRepository

    init(requestValue: RequestValue,
         completion: @escaping (ResultValue) -> Void,
         contactQueriesRepository: ContactQueriesRepository) {

        self.requestValue = requestValue
        self.completion = completion
        self.contactQueriesRepository = contactQueriesRepository
    }
    
    func start() -> Cancellable? {

        contactQueriesRepository.fetchRecentsQueries(maxCount: requestValue.maxCount, completion: completion)
        return nil
    }
}
