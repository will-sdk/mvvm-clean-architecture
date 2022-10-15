//
//  ContactQueriesListItemViewModel.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

class ContactQueryListItemViewModel {
    let query: String

    init(query: String) {
        self.query = query
    }
}

extension ContactQueryListItemViewModel: Equatable {
    static func == (lhs: ContactQueryListItemViewModel, rhs: ContactQueryListItemViewModel) -> Bool {
        return lhs.query == rhs.query
    }
}
