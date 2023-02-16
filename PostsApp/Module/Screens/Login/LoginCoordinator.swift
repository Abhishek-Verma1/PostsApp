//
//  LoginCoordinator.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit

final class LoginCoordinator: Coordinator, LoginViewNavigator {
    func showPosts() {
        //next View Controller
    }
    
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
        navigationController.setViewControllers([self.getRootViewController()], animated: true)
    }
    
    func getRootViewController() -> UIViewController {

            return factory.makeLoginViewController(navigationController: navigationController, navigator: self)
    }
}
