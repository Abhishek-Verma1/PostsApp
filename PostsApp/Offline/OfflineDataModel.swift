//
//  OfflineDataModel.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation
import Domain

class OfflineDataModel {
    
    static func authKeyExist() -> Bool {
        return UserDefaults.standard.object(forKey: Constants.UserDefaults.loginAuth) != nil
    }
    
    static func removeAuthKey() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.loginAuth)
    }
    
    static func getUserAuth() -> UserDataModel? {
        guard let data = UserDefaults.standard.object(forKey: Constants.UserDefaults.loginAuth) as? Data else {
            return nil
        }
        do {
            let userAuth = try JSONDecoder().decode(UserDataModel.self, from: data)
            return userAuth
        } catch let err {
            print(err)
        }
        return nil
    }
    
    static func saveAuth(auth: UserDataModel) {
        if let encoded = try? JSONEncoder().encode(auth) {
            UserDefaults.standard.set(encoded, forKey: Constants.UserDefaults.loginAuth)
        }
    }
    
    static func removeAllFavoritePost() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.favouritePost)
    }
    
    static func retriveFavouritePost() -> [Post] {
        guard let placesData = UserDefaults.standard.object(forKey: Constants.UserDefaults.favouritePost) as? Data else {
            return []
        }
        do {
            let storedItems = try JSONDecoder().decode([Post].self, from: placesData)
            return storedItems
        } catch let err {
            print(err)
        }
        return []
    }
    
    static func syncFavouritePost(posts: [Post]) {
        if let encoded = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(encoded, forKey: Constants.UserDefaults.favouritePost)
        }
    }
    
    static func removeUserData() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
