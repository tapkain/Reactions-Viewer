//
// RequestAuthSignIn.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


/** Request model for auth/signIn and auth/confirmSignUp endpoints. */

open class RequestAuthSignIn: Codable {

    /** Unique username assigned alias (email or phone). */
    public var username: String
    /** Password attribute requires numbers, lowercase and uppercase letters. */
    public var password: String


    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: String.self)

        try container.encode(username, forKey: "username")
        try container.encode(password, forKey: "password")
    }

    // Decodable protocol methods

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        username = try container.decode(String.self, forKey: "username")
        password = try container.decode(String.self, forKey: "password")
    }
}
