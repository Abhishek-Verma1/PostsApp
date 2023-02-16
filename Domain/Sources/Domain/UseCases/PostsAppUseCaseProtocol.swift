//
//  PostsAppUseCaseProtocol.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation
import Combine

public protocol PostsAppUseCaseProtocol {
    func getLoginAuth() -> AnyPublisher<[UserDataModel], Error>
    func fetchPosts()  -> AnyPublisher<[Post], Error>
}
