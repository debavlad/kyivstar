//
//  AppDelegate.swift
//  kyivstar
//
//  Created by Vladyslav Deba on 22.03.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: HomeCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let nc = UINavigationController()
        coordinator = HomeCoordinator(navigationController: nc)
        coordinator?.start()

        window?.rootViewController = nc
        window?.makeKeyAndVisible()

        return true
    }
}
