//
//  UserDataModel.swift
//  PostsApp
//
//  Created by Abhishek Verma on 14.02.23.
//  Copyright © 2023 JMD. All rights reserved.
//

import Foundation

#warning("Optimization is required in the next sprint.")

public struct UserDataModel: Codable {
    public let id: Int
    public let name: String
    public let username: String
    public let email: String
    public let address: Address
    public let phone: String
    public let website: String
    public let company: Company
    
    public init(id: Int, name: String, username: String, email: String, address: Address, phone: String, website: String, company: Company) {
        self.id = id
        self.name = name
        self.email = email
        self.username = username
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        try container.encode(address, forKey: .address)
        try container.encode(phone, forKey: .phone)
        try container.encode(website, forKey: .website)
        try container.encode(company, forKey: .company)
    }
}
