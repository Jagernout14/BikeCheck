//
//  BikeDetailViewModel.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 12.11.2026.
//

import Foundation

final class BikeDetailViewModel {
    
    // MARK: - Public Properties
    private(set) var bike: BikeDetail?
    var components: [Component] { bike?.components ?? [] }
    
    // MARK: - Private Properties
    private let client: NetworkClient
    private let bikeId: Int
    
    //MARK: - Callbacks
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onUpdate: (() -> Void)?
    
    // MARK: - Initializers
    init(client: NetworkClient, bikeId: Int) {
        self.client = client
        self.bikeId = bikeId
    }
    
    // MARK: - Public Methods
    func load() {
        onLoading?(true)
        Task { [weak self] in
            guard let self else { return }
            defer { onLoading?(false) }
            do {
                let bike: BikeDetail = try await client.request(BikeEndpoint.get(id: bikeId))
                self.bike = bike
                onUpdate?()
            } catch {
                onError?((error as? NetworkError)?.userMessage ?? "Что-то пошло не так. Попробуйте еще раз")
            }
        }
    }
}
