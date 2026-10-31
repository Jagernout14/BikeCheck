//
//  Service.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 31.10.2026.
//

import Foundation

nonisolated struct ServiceRecord: Decodable {
    let id: Int
    let componentId: Int
    let doneAt: String
    let mileageKm: Int
    let note: String?
    let createdAt: String
}

nonisolated struct NewService: Encodable {
    let doneAt: String
    let mileageKm: Int
    let note: String?
}

nonisolated struct ServiceHistoryItem: Decodable {
    let id: Int
    let componentId: Int
    let doneAt: String
    let mileageKm: Int
    let note: String?
    let createdAt: String
    let componentName: String
    let componentCategory: String
    let bikeId: Int
    let bikeName: String
}
