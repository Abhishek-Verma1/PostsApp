//
//  Company.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation

#warning("Optimization is required in the next sprint.")
public struct Company: Decodable, Encodable {
    public let name: String
    public let catchPhrase: String
    public let bs: String
    
    public init(name: String, catchPhrase: String, bs: String) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(catchPhrase, forKey: .catchPhrase)
        try container.encode(bs, forKey: .bs)
    }
}
