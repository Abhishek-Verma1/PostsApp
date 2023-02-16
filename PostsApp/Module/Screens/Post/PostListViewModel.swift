//
//  PostListViewModel.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Combine
import UIKit
import Domain

#warning("Optimization is required in the next sprint.")

/// States For View Model
enum PostViewModelState {
    case showRepositories([Post])
    case error(String)
}

final class PostListViewModel {
    let useCase: PostsAppUseCaseProtocol
    
    // MARK: - Private Properties
    private let userAuth: UserDataModel
    private var allPost: [Post] = []
    private var favoritePost: [Post] = [] {
        didSet {
            OfflineDataModel.syncFavouritePost(posts: favoritePost)
        }
    }
    
    private(set) lazy var stateDidUpdate = stateDidUpdateSubject.eraseToAnyPublisher()
    private let navigationController: UINavigationController
    private let stateDidUpdateSubject = PassthroughSubject<PostViewModelState, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Public Properties
    public var title = "My Post"
    
    @Published var changeSegmentValue = 0
    
    init(with useCase: PostsAppUseCaseProtocol, navigationController: UINavigationController, userAuth: UserDataModel) {
        self.useCase = useCase
        self.userAuth = userAuth
        self.navigationController = navigationController
    }
    
    // MARK: - Private methods
    func getAllPosts() {
        stateDidUpdateSubject.send(.showRepositories([]))
        self.getFavoritePost()
        self.useCase.fetchPosts().sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] posts in
            guard let self = self else { return }
            self.allPost = posts
                .filter({ $0.userId == self.userAuth.id })
                .map({ post in
                    var postData = post
                    let favPost = self.favoritePost.filter({
                        $0.id == postData.id
                    })
                    postData.isFavourite = favPost.count > 0
                    return postData
                })
            self.allPost = (self.allPost).sorted(by: { $0.id > $1.id })
            self.stateDidUpdateSubject.send(.showRepositories(self.allPost))
        }).store(in: &self.cancellable)
    }
    
    func getFavoritePost() {
        favoritePost = OfflineDataModel.retriveFavouritePost()
        favoritePost = favoritePost
            .map({ data in
                var post = data
                post.isFavourite = true
                return post
            })
    }
    
    func changePostShowState(onlyFavouritePost: Bool = false) {
        let displayPost = onlyFavouritePost ? favoritePost : allPost
        self.stateDidUpdateSubject.send(.showRepositories(displayPost))
    }
    
    func changeFavoriteStatus(id: Int, isSelected: Bool) {
        let selectedPost = self.allPost
            .filter({ $0.id == id})
            .map({ data -> Post in
                var post = data
                post.isFavourite = isSelected
                return post
            })
        
        if !selectedPost.isEmpty {
            self.favoritePost.removeAll { post in
                post.id == id
            }
            self.allPost.removeAll { post in
                post.id == id
            }
            self.allPost.append(contentsOf: selectedPost)
            self.allPost = self.allPost.sorted(by: { $0.id > $1.id })
            if isSelected {
                self.favoritePost.append(contentsOf: selectedPost)
            }
        }
    }
    
    func logout() {
        OfflineDataModel.removeUserData()
        navigationController.popViewController(animated: true)
    }
}
