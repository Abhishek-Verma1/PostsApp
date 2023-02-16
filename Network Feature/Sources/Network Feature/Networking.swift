//
//  Networking.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation
import Combine


final class ScheduleSerializer {

    func decode<T>(_ data: Data, forType: T.Type) -> T? where T: Decodable {

        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
            
        } catch {
            print("ScheduleSerializer decoding error : \(error)")
            return nil
        }

    }

}

/// This protocol the use to implement for remote networking api
public protocol Networking {
    
    /// Create a request and perform over the provided network api
    /// - Parameter request: APIRequestBuilder that have all the information for the call api request
    /// - Returns  AnyPublisher: Publisher which will be having the T generic type for response as decodable  or error in case of
    func request<T: Decodable>(request: APIRequestBuilder) -> AnyPublisher<T, NetworkError>
}

public final class Network: Networking {
    
    // MARK: - init
    public init() { }
    
    // MARK: - Networking Implementation
    public func request<T: Decodable>(request: APIRequestBuilder) -> AnyPublisher<T, NetworkError> {
        guard let request = request.makeRequest() else {
            return Fail(error: NetworkError.invalidRequest).eraseToAnyPublisher()
        }
        
       return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                if  let httpResponse = element.response as? HTTPURLResponse {
                    if 200...300 ~= httpResponse.statusCode {
                        return element.data
                    } else {
                        throw NetworkError(rawValue: httpResponse.statusCode) ?? .unknown
                    }
                } else {
                    throw NetworkError.unknown
                }
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError {
                $0 as? NetworkError ?? NetworkError.dataDecodingFail
            }
            .eraseToAnyPublisher()
    }
}
