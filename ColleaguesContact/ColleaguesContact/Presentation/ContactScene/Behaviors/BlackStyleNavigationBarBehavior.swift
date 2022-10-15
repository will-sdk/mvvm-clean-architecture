//
//  BlackStyleNavigationBarBehavior.swift
//  ColleaguesContact
//
//  Created by Willy on 14/10/2022.
//

import UIKit

struct BlackStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {

    func viewDidLoad(viewController: UIViewController) {

        viewController.navigationController?.navigationBar.barStyle = .black
    }
}
