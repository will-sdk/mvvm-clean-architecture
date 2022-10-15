//
//  APIEndpoints.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

struct APIEndpoints {
    
    static func getContact(with contactRequest: ContactRequest) -> Endpoint<[ContactResponse]> {

        return Endpoint(path: "people",
                        method: .get,
                        queryParametersEncodable: contactRequest)
    }
}
