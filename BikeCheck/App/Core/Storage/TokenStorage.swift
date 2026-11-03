//
//  TokenStorage.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 01.11.2026.
//

import Foundation

nonisolated protocol TokenStorageProtocol {
    var token: String? { get }
    
    func save(_ token: String) throws
    func clear() throws
}

nonisolated final class TokenStorage: TokenStorageProtocol {
    
    private(set) var token: String?
    
    func save(_ token: String) throws {
        self.token = token
    }
    
    func clear() throws {
        self.token = nil
    }
}
