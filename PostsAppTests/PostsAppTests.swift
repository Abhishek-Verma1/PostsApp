//
//  PostsAppTests.swift
//  PostsAppTests
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import XCTest
import Domain
import Data
import Combine

#warning("Optimization is required in the next sprint.")

@testable import PostsApp

class PostsAppTests: XCTestCase {
    private var cancellable = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAuthKey() throws {
        OfflineDataModel.removeAuthKey()
        XCTAssertFalse(OfflineDataModel.authKeyExist())
        OfflineDataModel.saveAuth(auth: getFakeUsers())
        XCTAssertTrue(OfflineDataModel.authKeyExist())
    }
    
    func testApplicationFlowIfNotLogin() {
        OfflineDataModel.removeAuthKey()
        let navigationController = UINavigationController()
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        XCTAssertTrue(loginCoordinator.getRootViewController() is LoginViewController)
    }
    
    func testApplicationFlowIfLogin() {
        OfflineDataModel.removeAuthKey()
        OfflineDataModel.saveAuth(auth: self.getFakeUsers())
        let navigationController = UINavigationController()
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        XCTAssertFalse(loginCoordinator.getRootViewController() is PostViewController)
    }
    
    func testUserAPI() {
        // Given
        let expectation = self.expectation(description: "get User Auth Data")
        let useCase = PostsAppUseCase()
        let navigationController = UINavigationController()
        let factory = ViewControllersFactory()
        let viewModel = LoginViewModel.init(useCase: useCase, navigationController: navigationController, factory)
        
        viewModel.useCase.getLoginAuth().sink(receiveCompletion: {  _ in
            XCTFail("Fail to retrive Data.")
        }, receiveValue: {  _ in
            expectation.fulfill()
        }).store(in: &self.cancellable)
        waitForExpectations(timeout: 20)
    }
    
    func testPostAPI() {
        // Given
        let expectation = self.expectation(description: "get Post Data")
        let useCase = PostsAppUseCase()
        let navigationController = UINavigationController()
        let factory = ViewControllersFactory()
        let viewModel = LoginViewModel.init(useCase: useCase, navigationController: navigationController, factory)
        
        viewModel.useCase.fetchPosts().sink(receiveCompletion: {  _ in
            XCTFail("Fail to retrive Data.")
        }, receiveValue: {  _ in
            expectation.fulfill()
        }).store(in: &self.cancellable)
        waitForExpectations(timeout: 20)
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func getFakeUsers() -> UserDataModel {
        return UserDataModel(id: 8,
                     name: "fakename",
                     username: "fake.username",
                     email: "fake@username.com",
                     address: Address(street: "street", suite: "suite", city: "city", zipcode: "zipcode", geo: Geo(lat: "1.234", lng: "3.456")),
                     phone: "phone",
                     website: "website",
                     company: Company(name: "company name", catchPhrase: "catch phrase", bs: "bs"))
    }

}
