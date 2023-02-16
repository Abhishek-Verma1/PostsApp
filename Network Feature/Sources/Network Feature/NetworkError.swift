//
//  NetworkError.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation

public enum NetworkError: Int, Error {
    /// Error when user is not having valide token
    case unauthorized = 401
    
    ///  Error when no internet
    case noInternet = -1009
    
    /// Error When no data connection
    case noDataConnection = -1020
    
    /// Error while the request is having some invalid information like url is nil
    case invalidRequest
    
    /// Error when the decoding data is failed
    case dataDecodingFail
    
    /// Something unknown
    case unknown
}

/// NetworkError Extension for localized description
extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noInternet, .noDataConnection:
            return "Can't connect to internet"
        case .invalidRequest:
            return "Bad input request"
        case .dataDecodingFail:
            return "Data decoding failed"
        case .unauthorized:
            return "Invalid token kindly create your github token and add to DataConstants ->APIData -> apiToken"
        case .unknown:
            return "Something went wrong!"
        }
    }
}
