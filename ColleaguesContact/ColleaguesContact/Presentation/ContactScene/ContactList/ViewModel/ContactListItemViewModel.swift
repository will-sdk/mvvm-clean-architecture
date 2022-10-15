//
//  ContactListItemViewModel.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

struct ContactListItemViewModel: Equatable {
    let name: String
    let email: String
    let favouriteColor: String
    let jobtitle: String
    let posterImagePath: String?
}

extension ContactListItemViewModel {

    init(contact: Contact) {
        self.name = "\(contact.firstName ?? "") \(contact.lastName ?? "")"
        self.posterImagePath = contact.avatar
        self.email = contact.email ?? ""
        self.favouriteColor = contact.favouriteColor ?? ""
        self.jobtitle = contact.jobtitle ?? ""
    }
}
