//
//  PostsAppUseCase.swift
//  
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation
import Domain
import Combine
import Network_Feature

final public class PostsAppUseCase: PostsAppUseCaseProtocol {
    // MARK: - Private Properties
    private let repository: PostsAppRepositoryProtocol
    
    // MARK: - init
    public init(repository: PostsAppRepositoryProtocol = PostsAppRepository()) {
        self.repository = repository
    }
    
    // MARK: - PostsAppUseCaseProtocol Implementation
    public func getLoginAuth() -> AnyPublisher<[UserDataModel], Error> {
        return repository.fetchUsers()
            .map { $0 }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
    
    public func fetchPosts() -> AnyPublisher<[Post], Error> {
        return repository.fetchPosts()
            .map { $0 }
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
