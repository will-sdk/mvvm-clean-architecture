//
//  AppFlowCoordinator.swift
//  ColleaguesContact
//
//  Created by Willy on 14/10/2022.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let contactSceneDIContainer = appDIContainer.makeContactSceneDIContainer()
        let flow = contactSceneDIContainer.makeContactSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
