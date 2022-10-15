//
//  DefaultContactRepository.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

final class DefaultContactRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension DefaultContactRepository: ContactRepository {

    public func fetchContactList(query: ContactQuery, completion: @escaping (Result<ContactData, Error>) -> Void) -> Cancellable? {
        var arrayContact = [Contact]()
        let requestData = ContactRequest(search: query.query)
        let task = RepositoryTask()
        
        let endpoint = APIEndpoints.getContact(with: requestData)
        task.networkTask = self.dataTransferService.request(with: endpoint) { result in
            
            guard !task.isCancelled else { return }
            
            switch result {
            case .success(let responseData):
                if responseData.count > 0 {
                    for responseDataEnumerated in responseData.enumerated() {
                        let responseDataTransform = responseData[responseDataEnumerated.offset].toDomainContact()
                        arrayContact.append(responseDataTransform)
                    }
                }
                let contactData = ContactData(contact: arrayContact)
                completion(.success(contactData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return task
    }
}
