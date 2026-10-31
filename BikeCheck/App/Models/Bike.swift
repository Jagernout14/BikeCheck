//
//  Bike.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 31.10.2026.
//

import Foundation

nonisolated struct Bike: Decodable {
    let id: Int
    let name: String
    let photoUrl: String?
    let componentCount: Int
    let totalWeightG: Int
    let createdAt: String
}

nonisolated struct NewBike: Encodable {
    let name: String
    let photoUrl: String?
}

nonisolated struct BikeDetail: Decodable {
    let id: Int
    let name: String
    let photoUrl: String?
    let componentCount: Int
    let totalWeightG: Int
    let createdAt: String
    let components: [Component]
}

