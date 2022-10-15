//
//  ContactQueriesRepository.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

protocol ContactQueriesRepository {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ContactQuery], Error>) -> Void)
    func saveRecentQuery(query: ContactQuery, completion: @escaping (Result<ContactQuery, Error>) -> Void)
}
