//
//  ConnectionError.swift
//
//  Created by Willy on 11/10/2022.
//  Copyright (c) 2022 All rights reserved.
//

import Foundation

public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
