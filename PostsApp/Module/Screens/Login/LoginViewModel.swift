//
//  LoginViewModel.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

//import Domain
import Combine
import UIKit
import Domain

protocol LoginViewNavigator: AnyObject {
    func showPosts()
}

final class LoginViewModel {
    // MARK: - Public Properties
    let viewControllersFactory: ViewControllersFactory
    let useCase: PostsAppUseCaseProtocol
    
    private let navigationController: UINavigationController
    
    init(useCase: PostsAppUseCaseProtocol, navigationController: UINavigationController, _ viewControllersFactory: ViewControllersFactory) {
        self.navigationController = navigationController
        self.viewControllersFactory = viewControllersFactory
        self.useCase = useCase
    }
    
}

extension LoginViewModel: ListViewNavigator {
    func showPostListView(userAuth: UserDataModel) {
        let postViewController = viewControllersFactory.makePostViewController(navigationController: navigationController, userAuth: userAuth)
        navigationController.pushViewController(postViewController, animated: true)
    }
}
