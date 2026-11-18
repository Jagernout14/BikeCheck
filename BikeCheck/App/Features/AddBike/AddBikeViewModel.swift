//
//  AddBikeViewModel.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 18.11.2026.
//

import Foundation

final class AddBikeViewModel {
    
    //MARK: - Public Properties
    var newBikeName = "" {
        didSet {
            validateForm()
        }
    }
    
    //MARK: - Private Properties
    private let client: NetworkClient
    private var isLoading = false
    private var trimmedName: String {
        newBikeName.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    //MARK: - Callbacks
    var onSaveEnabledChange: ((Bool) -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onCreated: ((Int) -> Void)?
    
    //MARK: - Initializers
    init(client: NetworkClient) {
        self.client = client
    }
    
    //MARK: - Public Methods
    func create() {
        guard !isLoading else { return }
        onLoading?(true)
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            defer {
                onLoading?(false)
                isLoading = false
            }
            do {
                let newBike = NewBike(name: trimmedName, photoUrl: nil)
                let bike: Bike = try await client.request(BikeEndpoint.create(newBike))
                onCreated?(bike.id)
            } catch {
                onError?((error as? NetworkError)?.userMessage ?? "Не получилось создать велосипед, попробуйте снова")
            }
        }
    }
    
    //MARK: - Private Methods
    private func validateForm() {
        let isValid = !trimmedName.isEmpty
        onSaveEnabledChange?(isValid)
    }
}
