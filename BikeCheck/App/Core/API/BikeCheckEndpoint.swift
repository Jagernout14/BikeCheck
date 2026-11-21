//
//  BikeCheckEndpoint.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 01.11.2026.
//

import Foundation

nonisolated protocol BikeCheckEndpoint: Endpoint {}

nonisolated extension BikeCheckEndpoint {
    var baseURL: String {
        "http://127.0.0.1:8000"
    }
    
    var encoder: JSONEncoder {
        BikeCheckCoding.encoder
    }
}
