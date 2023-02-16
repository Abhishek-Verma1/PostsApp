//
//  APIRequestBuilder.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation

/// Define to create the request for the network
public struct APIRequestBuilder {
    // MARK: - Private Properties
    private let scheme: String
    private let host: String
    private let path: String
    private let httpMethods: HttpMethods
    private let parameters: Encodable?
    private var headers: [String: String]?
    
    // MARK: - Init
    public init(scheme: String = "https", host: String, path: String, httpMethods: HttpMethods = .Get, parameters: Encodable? = nil, headers: [String: String]? = nil) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.httpMethods = httpMethods
        self.parameters = parameters
        self.headers = headers
    }
    
    // MARK: - Public Methods
    
    /// Make the request with the provided information
    /// - Returns  URLRequest: Convert the all provided information to the URLRequest
    public func makeRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = self.scheme
        components.host = self.host
        components.path = self.path
        
        
        guard let request = components.url.map({ URLRequest(url: $0) }) else {
            return nil
        }
        
        return request
    }
}
