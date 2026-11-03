//
//  KeychainTokenStorage.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 03.11.2026.
//

import Foundation
import Security

nonisolated enum KeychainError: Error {
    case unexpectedStatus(OSStatus)
    case encoding
}

nonisolated final class KeychainTokenStorage: TokenStorageProtocol {
    
    private let service = "ru.jagernout14.BikeCheck"
    private let account = "accessToken"
    
    private var baseQuery: [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }
    
    var token: String? {
        var query = baseQuery
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        switch status {
        case errSecSuccess:
            guard let data = result as? Data else {
                return nil
            }
            return String(data: data, encoding: .utf8)
        case errSecItemNotFound:
            return nil
        default:
            print("Keychain read error:", status)
            return nil
        }
    }
    
    func clear() throws {
        let status = SecItemDelete(baseQuery as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func save(_ token: String) throws {
        guard let data = token.data(using: .utf8) else {
            throw KeychainError.encoding
        }
        
        try clear()
        
        var query = baseQuery
        query[kSecValueData as String] = data
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
