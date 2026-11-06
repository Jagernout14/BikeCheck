//
//  SelectedBikeStorageProtocol.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 06.11.2026.
//

import Foundation

nonisolated protocol SelectedBikeStorageProtocol {
    var bikeId: Int? { get }
    
    func save(_ bikeId: Int)
    func clear()
}
