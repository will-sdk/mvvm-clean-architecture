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
                     favouriteColor: String = "pink",
                     avatar: String = "https://randomuser.me/api/portraits/women/IsaryAmairani_128.jpg",
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
