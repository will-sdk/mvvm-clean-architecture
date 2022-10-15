//
//  ContactResponseStorage.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

protocol ContactResponseStorage {
    func getResponse(for request: ContactRequest, completion: @escaping (Result<[ContactResponse?], Error>) -> Void)
}
