//
//  ContactRepository.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

protocol ContactRepository {
    @discardableResult
    func fetchContactList(query: ContactQuery,
                         completion: @escaping (Result<ContactData, Error>) -> Void) -> Cancellable?
}
