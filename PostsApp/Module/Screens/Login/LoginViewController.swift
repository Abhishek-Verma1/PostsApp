//
//  LoginViewController.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import UIKit
import Combine
import Domain

#warning("Optimization is required in the next sprint.")
final class LoginViewController: UIViewController {
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    // MARK: - Private Properties
    private let viewModel: LoginViewModel
    private var cancellable = Set<AnyCancellable>()
    
    public var buttonPressedSubject = PassthroughSubject<UIButton, Error>()
    
    // MARK: - Init
    init?(coder: NSCoder, viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("viewModel(LoginViewModel) must provided while initialisation")
    }
    
    // MARK: - Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        navigatePostView()
        hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Private Methods
    private func navigatePostView() {
        if let userAuth = OfflineDataModel.getUserAuth() {
            return self.viewModel.showPostListView(userAuth: userAuth)
        }
    }
    
    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bind() {
        bindTextField()
        bindButton()
    }
    
    private func bindTextField() {
        textField.delegate = self
        
        textField.publisher(for: \.text)
            .map { _ in !(self.textField.text ?? "").isEmpty }
                    .assign(to: \.isEnabled, on: loginButton)
                    .store(in: &cancellable)
    }
    
    func saveLoginAuth(user: UserDataModel) -> Bool {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: Constants.UserDefaults.loginAuth)
            return true
        }
        return false
    }
    
    private func bindButton() {
        loginButton.publisher(for: .touchUpInside)
            .sink(receiveValue: {_ in
                self.showLoadingMask(isOverFullscreen: true)
                self.viewModel.useCase.getLoginAuth().sink(receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.hideLoadingMask {
                            switch completion {
                            case .finished: break
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }, receiveValue: { [weak self] users in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.hideLoadingMask {
                            let loginUser = users
                                .filter({ $0.username.lowercased() == (self.textField.text ?? "").lowercased()})
                                .compactMap({
                                    $0
                                }).first
                            if let loginUserAuth = loginUser {
                                OfflineDataModel.saveAuth(auth: loginUserAuth)
                                self.viewModel.showPostListView(userAuth: loginUserAuth)
                            } else {
                                self.showAlert("User does not exist. Please try again!")
                            }
                        }
                    }
                }).store(in: &self.cancellable)
            })
            .store(in: &cancellable)
    }
    
    func createActivityIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.startAnimating()
        indicator.isHidden = true
        return indicator
    }
}

// MARK: - Extension for Tableview datasource
fileprivate extension LoginViewController {
    enum Section: CaseIterable {
        case Posts
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
