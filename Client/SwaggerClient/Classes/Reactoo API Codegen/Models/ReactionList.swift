//
// ReactionList.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** an array of Reaction models */

open class ReactionList: Codable {

    public var size: Int
    public var startKey: String?
    public var items: [Reaction]?
    public var users: [User]?


    
    public init(size: Int, startKey: String?, items: [Reaction]?, users: [User]?) {
        self.size = size
        self.startKey = startKey
        self.items = items
        self.users = users
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encode(size, forKey: "size")
        try container.encodeIfPresent(startKey, forKey: "startKey")
        try container.encodeIfPresent(items, forKey: "items")
        try container.encodeIfPresent(users, forKey: "users")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        size = try container.decode(Int.self, forKey: "size")
        startKey = try container.decodeIfPresent(String.self, forKey: "startKey")
        items = try container.decodeIfPresent([Reaction].self, forKey: "items")
        users = try container.decodeIfPresent([User].self, forKey: "users")
    }
}

