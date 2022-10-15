//
//  DefaultContactQueriesRepository.swift
//  ColleaguesContact
//
//  Created by Willy on 13/10/2022.
//

import Foundation

final class DefaultContactQueriesRepository {
    
    private let dataTransferService: DataTransferService
    private var contactQueriesPersistentStorage: ContactQueriesStorage
    
    init(dataTransferService: DataTransferService,
         contactQueriesPersistentStorage: ContactQueriesStorage) {
        self.dataTransferService = dataTransferService
        self.contactQueriesPersistentStorage = contactQueriesPersistentStorage
    }
}

extension DefaultContactQueriesRepository: ContactQueriesRepository {
    
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ContactQuery], Error>) -> Void) {
        return contactQueriesPersistentStorage.fetchRecentsQueries(maxCount: maxCount, completion: completion)
    }
    
    func saveRecentQuery(query: ContactQuery, completion: @escaping (Result<ContactQuery, Error>) -> Void) {
        contactQueriesPersistentStorage.saveRecentQuery(query: query, completion: completion)
    }
}
