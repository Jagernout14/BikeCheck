//
//  BikeCheckCoding.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 01.11.2026.
//

import Foundation

nonisolated enum BikeCheckCoding {
    static let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
