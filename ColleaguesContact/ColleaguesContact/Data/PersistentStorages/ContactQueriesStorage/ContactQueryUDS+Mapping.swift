//
//  ContactQueryUDS+Mapping.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

struct ContactQueriesListUDS: Codable {
    var list: [ContactQueryUDS]
}

struct ContactQueryUDS: Codable {
    let query: String
}

extension ContactQueryUDS {
    init(contactQuery: ContactQuery) {
        query = contactQuery.query
    }
}

extension ContactQueryUDS {
    func toDomain() -> ContactQuery {
        return .init(query: query)
    }
}
