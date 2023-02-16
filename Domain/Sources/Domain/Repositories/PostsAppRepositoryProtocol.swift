//
//  PostsAppRepositoryProtocol.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation
import Combine

public protocol PostsAppRepositoryProtocol {
    func fetchUsers() -> AnyPublisher<[UserDataModel], Error>
    func fetchPosts() -> AnyPublisher<[Post], Error>
}
