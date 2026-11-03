//
//  TokenStorageProtocol.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 03.11.2026.
//

import Foundation

nonisolated protocol TokenStorageProtocol {
    var token: String? { get }
    
    func save(_ token: String) throws
    func clear() throws
}
