//
//  DataTransferError+ConnectionError.swift
//
//  Created by Willy on 11/10/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation

extension DataTransferError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
