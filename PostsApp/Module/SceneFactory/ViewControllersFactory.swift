//
//  ViewControllersFactory.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit
import Domain
import Data

protocol ListViewNavigator: AnyObject {
    func showPostListView(userAuth: UserDataModel)
}

final class ViewControllersFactory {
    
    private let useCase: PostsAppUseCaseProtocol
    
    // MARK: - Init
    init(useCase: PostsAppUseCaseProtocol = PostsAppUseCase() ) {
        self.useCase = useCase
    }
    
    // MARK: - Public Methods
    func makeLoginViewController(navigationController: UINavigationController, navigator: LoginViewNavigator) -> LoginViewController {
        let storyboard = UIStoryboard(name: .Main, bundle: Bundle.main)
        let viewModel = LoginViewModel(useCase: useCase, navigationController: navigationController, self)
        let viewController: LoginViewController = storyboard.instantiateViewController(identifier: LoginViewController.storyboardID()) {
            LoginViewController(coder: $0, viewModel: viewModel)
        }
        return viewController
    }
    
    func makePostViewController(navigationController: UINavigationController, userAuth: UserDataModel) -> PostViewController {
        let storyboard = UIStoryboard(name: .Main, bundle: Bundle.main)
        let viewModel = PostListViewModel(with: useCase, navigationController: navigationController, userAuth: userAuth)
        let viewController: PostViewController = storyboard.instantiateViewController(identifier: PostViewController.storyboardID()) {
            PostViewController(coder: $0, viewModel: viewModel)
        }
        return viewController
    }
}
