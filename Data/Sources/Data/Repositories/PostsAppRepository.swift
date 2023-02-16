//
//  PostsAppRepository.swift
//  
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation
import Domain
import Network_Feature
import Combine

public struct PostsAppRepository: PostsAppRepositoryProtocol {
    // MARK: - Private Properties
    private let network: Networking
    
    // MARK: - init
    public init(network: Networking = Network()) {
        self.network = network
    }
    
    // MARK: - PostsAppRepositoryProtocol Implementation
    public func fetchUsers() -> AnyPublisher<[UserDataModel], Error> {
        let requestBuilder = APIRequestBuilder(host: DataConstants.APIUrls.baseURL,
                                               path: DataConstants.APIPaths.users)
        return self.network.request(request: requestBuilder)
            .mapError { $0 }
            .map {
                $0 as [UserDataModel]
            }
            .eraseToAnyPublisher()
    }
    
    public func fetchPosts() -> AnyPublisher<[Post], Error> {
        let requestBuilder = APIRequestBuilder(host: DataConstants.APIUrls.baseURL,
                                               path: DataConstants.APIPaths.posts)
        return self.network.request(request: requestBuilder)
            .mapError { $0 }
            .eraseToAnyPublisher()
    }
}
