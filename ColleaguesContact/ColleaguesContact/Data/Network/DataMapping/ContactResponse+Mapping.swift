//
//  ContactResponse+Mapping.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

// MARK: - Data Transfer Object

struct ContactResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case avatar
        case email
        case createdAt
        case favouriteColor
        case jobtitle
    }
  
    let id: String?
    let firstName: String?
    let lastName: String?
    let avatar: String?
    let email: String?
    let createdAt: String?
    let favouriteColor: String?
    let jobtitle: String?
}


// MARK: - Mappings to Domain

extension ContactResponse {
    func toDomainContact() -> Contact {
        return .init(id: id ?? "",
                     firstName: firstName ?? "",
                     lastName: lastName ?? "",
                     email: email ?? "",
                     jobtitle: jobtitle ?? "",
                     favouriteColor: favouriteColor ?? "",
                     avatar: avatar ?? "",
                     createdAt: dateFormatter.date(from: createdAt ?? ""))
    }
}



// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
