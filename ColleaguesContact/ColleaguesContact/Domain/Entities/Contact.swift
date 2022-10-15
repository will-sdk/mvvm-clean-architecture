//
//  Contact.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

import Foundation

struct Contact: Equatable, Identifiable {
    typealias Identifier = String?
   
    let id: Identifier
    let firstName: String?
    let lastName: String?
    let email: String?
    let jobtitle: String?
    let favouriteColor: String?
    let avatar: String?
    let createdAt: Date?
}

struct ContactData: Equatable {
    let contact: [Contact]
}

