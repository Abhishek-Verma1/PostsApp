//
//  Geo.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation

#warning("Optimization is required in the next sprint.")
public struct Geo: Decodable, Encodable {
    public let lat: String
    public let lng: String
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(lat, forKey: .lat)
        try container.encode(lng, forKey: .lng)
    }
    
    public init(lat: String, lng: String) {
        self.lat = lat
        self.lng = lng
    }
}
