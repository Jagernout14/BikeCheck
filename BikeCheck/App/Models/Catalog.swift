//
//  Catalog.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 31.10.2026.
//

import Foundation

nonisolated struct CatalogItem: Decodable {
    let id: Int
    let name: String
    let brand: String?
    let category: String
    let weightG: Int?
    let needsService: Bool
    let authorId: Int?
    let isMine: Bool
    let createdAt: String
}
