//
//  TokenStorage.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 01.11.2026.
//

import Foundation

nonisolated protocol TokenStorageProtocol {
    var token: String? { get }
}

nonisolated final class TokenStorage: TokenStorageProtocol {
    var token: String?
    
}
