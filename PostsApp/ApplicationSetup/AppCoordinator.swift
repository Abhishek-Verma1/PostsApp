//
//  AppCoordinator.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: - Private Properties
    private let window: UIWindow
    
    // MARK: - Init
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Coordinator Implementation
    func start() {
        let navigationController = UINavigationController()
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        loginCoordinator.start()
    }
}
