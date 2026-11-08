//
//  GarageViewModel.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 08.11.2026.
//

import Foundation

final class GarageViewModel {
    
    // MARK: - Public Properties
    var selectedBike: Bike? {
        bikes.first { $0.id == selectedBikeId }
    }
    
    private(set) var bikes: [Bike] = []
    
    // MARK: - Private Properties
    private let client: NetworkClient
    private let selectedBikeStorage: SelectedBikeStorageProtocol
    
    private var selectedBikeId: Int?
    
    //MARK: - Callbacks
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onUpdate: (() -> Void)?
    
    // MARK: - Initializers
    init(client: NetworkClient, selectedBikeStorage: SelectedBikeStorageProtocol) {
        self.client = client
        self.selectedBikeStorage = selectedBikeStorage
    }
    
    // MARK: - Public Methods
    func load() {
        onLoading?(true)
        Task { [weak self] in
            guard let self else { return }
            defer { onLoading?(false) }
            do {
                let bikes: [Bike] = try await client.request(BikeEndpoint.list)
                self.bikes = bikes
                resolveSelectedBike()
                onUpdate?()
            } catch {
                onError?((error as? NetworkError)?.userMessage ?? "Не удалось получить данные")
            }
        }
    }
    
    private func resolveSelectedBike() {
        guard !bikes.isEmpty else {
            selectedBikeStorage.clear()
            selectedBikeId = nil
            return
        }
        
        if let savedId = selectedBikeStorage.bikeId,
           bikes.contains(where: { $0.id == savedId }) {
            selectedBikeId = savedId
            return
        }
        
        let firstId = bikes[0].id
        selectedBikeId = firstId
        selectedBikeStorage.save(firstId)
    }
}
