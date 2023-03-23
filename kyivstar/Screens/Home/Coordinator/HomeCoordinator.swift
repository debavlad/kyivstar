//
//  HomeCoordinator.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 23.03.2023.
//

import UIKit

protocol Coordinator {
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }

    func start()
}

class HomeCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = HomeViewController()
        // TODO: - Inject `HomeViewModel`
        navigationController.pushViewController(vc, animated: false)
    }
}
