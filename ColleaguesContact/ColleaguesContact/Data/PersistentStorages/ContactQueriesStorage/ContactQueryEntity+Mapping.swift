//
//  ContactQueryEntity+Mapping.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation
import CoreData

extension ContactQueryEntity {
    convenience init(contactQuery: ContactQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = contactQuery.query
        createdAt = Date()
    }
}

extension ContactQueryEntity {
    func toDomain() -> ContactQuery {
        return .init(query: query ?? "")
    }
}
