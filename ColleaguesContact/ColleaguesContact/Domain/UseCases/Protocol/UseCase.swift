//
//  UseCase.swift
//  ColleaguesContact
//
//  Created by Willy on 12/10/2022.
//

import Foundation

public protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
