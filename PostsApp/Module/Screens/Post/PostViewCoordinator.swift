//
//  PostViewCoordinator.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit

final class PostViewCoordinator: Coordinator {
    // MARK: - Private Properties
    private let navigationController: UINavigationController
    private let factory: ViewControllersFactory
    
    // MARK: - init
    init(navigationController: UINavigationController, factory: ViewControllersFactory = ViewControllersFactory()) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    // MARK: - Coordinator Implementation
    func start() {
        var searchViewController: UIViewController
        if let userAuth = OfflineDataModel.getUserAuth() {
            searchViewController = factory.makePostViewController(navigationController: navigationController, userAuth: userAuth)
        } else {
            searchViewController = factory.makeLoginViewController(navigationController: navigationController, navigator: self)
        }
        navigationController.setViewControllers([searchViewController], animated: true)
    }
}

extension PostViewCoordinator: LoginViewNavigator {
    func showPosts() {
        
    }
}
