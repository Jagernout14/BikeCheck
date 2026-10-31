//
//  Component.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 31.10.2026.
//

import Foundation

nonisolated struct Component: Decodable {
    let id: Int
    let bikeId: Int
    let installedAt: String
    let note: String?
    let lastServiceAt: String?
    let lastServiceMileageKm: Int?
    let catalog: CatalogItem
}

nonisolated struct NewComponent: Encodable {
    let catalogId: Int
    let installedAt: String
}
