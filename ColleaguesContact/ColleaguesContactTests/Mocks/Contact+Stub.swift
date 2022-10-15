//
//  Contact+Stub.swift
//  ColleaguesContactTests
//
//  Created by Willy on 15/10/2022.
//

import Foundation

extension Contact {
    static func stub(id: Contact.Identifier = "1",
                     firstName: String = "Maggie" ,
                     lastName: String = "Brekke",
                     email: String? = "Crystel.Nicolas61@hotmail.com",
                     jobtitle: String = "Future Functionality Strategist",
                     favouriteColor: String = "overview1",
                     avatar: String = "pink",
                     createdAt: Date? = nil) -> Self {
        Contact(id: id,
                firstName: firstName,
                lastName: lastName,
                email: email,
                jobtitle: jobtitle,
                favouriteColor: favouriteColor,
                avatar: avatar,
                createdAt: createdAt)
    }
}
