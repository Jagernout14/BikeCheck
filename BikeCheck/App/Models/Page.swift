//
//  Page.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 31.10.2026.
//

import Foundation

nonisolated struct Page<T: Decodable>: Decodable {
    let items: [T]
    let total: Int
    let limit: Int
    let offset: Int
}
