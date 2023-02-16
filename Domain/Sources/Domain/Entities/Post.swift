//
//  Post.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation

#warning("Optimization is required in the next sprint.")
public struct Post: Codable, Hashable {
    public let userId: Int
    public let id: Int
    public let title: String
    public let body: String
    public var isFavourite: Bool? = false
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}
