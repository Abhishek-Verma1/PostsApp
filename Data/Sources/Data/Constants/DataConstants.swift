//
//  DataConstants.swift
//  
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation

public struct DataConstants {
    /// Defines all the base api urls
    public struct APIUrls {
        public static let baseURL  = Bundle.main.infoForKey("Api URL") ?? ""
    }
    
    /// Define all the paths for the urls
    public struct APIPaths {
        public static let users  = "/users"
        public static let posts  = "/posts"
    }
}
