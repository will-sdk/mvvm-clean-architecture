//
//  UserDefaultsContactQueriesStorage.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

final class UserDefaultsContactQueriesStorage {
    private let maxStorageLimit: Int
    private let recentsContactQueriesKey = "recentsContactQueries"
    private var userDefaults: UserDefaults
    
    init(maxStorageLimit: Int, userDefaults: UserDefaults = UserDefaults.standard) {
        self.maxStorageLimit = maxStorageLimit
        self.userDefaults = userDefaults
    }

    private func fetchContactQuries() -> [ContactQuery] {
        if let queriesData = userDefaults.object(forKey: recentsContactQueriesKey) as? Data {
            if let contactQueryList = try? JSONDecoder().decode(ContactQueriesListUDS.self, from: queriesData) {
                return contactQueryList.list.map { $0.toDomain() }
            }
        }
        return []
    }

    private func persist(contactQuries: [ContactQuery]) {
        let encoder = JSONEncoder()
        let contactQueryUDSs = contactQuries.map(ContactQueryUDS.init)
        if let encoded = try? encoder.encode(ContactQueriesListUDS(list: contactQueryUDSs)) {
            userDefaults.set(encoded, forKey: recentsContactQueriesKey)
        }
    }
}

extension UserDefaultsContactQueriesStorage: ContactQueriesStorage {

    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ContactQuery], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchContactQuries()
            queries = queries.count < self.maxStorageLimit ? queries : Array(queries[0..<maxCount])
            completion(.success(queries))
        }
    }

    func saveRecentQuery(query: ContactQuery, completion: @escaping (Result<ContactQuery, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchContactQuries()
            self.cleanUpQueries(for: query, in: &queries)
            queries.insert(query, at: 0)
            self.persist(contactQuries: queries)

            completion(.success(query))
        }
    }
}


// MARK: - Private
extension UserDefaultsContactQueriesStorage {

    private func cleanUpQueries(for query: ContactQuery, in queries: inout [ContactQuery]) {
        removeDuplicates(for: query, in: &queries)
        removeQueries(limit: maxStorageLimit - 1, in: &queries)
    }

    private func removeDuplicates(for query: ContactQuery, in queries: inout [ContactQuery]) {
        queries = queries.filter { $0 != query }
    }

    private func removeQueries(limit: Int, in queries: inout [ContactQuery]) {
        queries = queries.count <= limit ? queries : Array(queries[0..<limit])
    }
}
