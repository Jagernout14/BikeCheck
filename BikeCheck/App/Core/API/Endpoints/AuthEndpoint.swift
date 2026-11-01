//
//  AuthEndpoint.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 01.11.2026.
//

import Foundation

nonisolated enum AuthEndpoint: BikeCheckEndpoint {
    case register(Credentials)
    case login(Credentials)
    case me
    
    var path: String {
        switch self {
        case .register:
            return "/auth/register"
        case .login:
            return "/auth/login"
        case .me:
            return "/auth/me"
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .register(let credentials), .login(let credentials):
            return credentials
        case .me:
            return nil
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .register, .login:
            return .post
        case .me:
            return .get
        }
    }
    
    var requiresAuth: Bool {
        switch self {
        case .register, .login:
            return false
        case .me:
            return true
        }
    }
}
