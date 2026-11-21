//
//  Auth.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 31.10.2026.
//

import Foundation

nonisolated struct Credentials: Encodable {
    let email: String
    let password: String
}

nonisolated struct AuthResponse: Decodable {
    let accessToken: String
    let tokenType: String
    let user: User
}

nonisolated struct User: Decodable {
    let id: Int
    let email: String
    let createdAt: String
}
