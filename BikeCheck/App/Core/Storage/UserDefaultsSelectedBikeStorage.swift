//
//  UserDefaultsSelectedBikeStorage.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 06.11.2026.
//

import Foundation

nonisolated final class UserDefaultsSelectedBikeStorage: SelectedBikeStorageProtocol {
    
    // MARK: - Public Properties
    var bikeId: Int? {
        defaults.object(forKey: key) as? Int
    }
    
    // MARK: - Private Properties
    private let defaults: UserDefaults
    private let key = "selectedBikeKey"
    
    // MARK: - Initializers
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    // MARK: - Public Methods
    func save(_ bikeId: Int) {
        defaults.set(bikeId, forKey: key)
    }
    
    func clear() {
        defaults.removeObject(forKey: key)
    }
}
