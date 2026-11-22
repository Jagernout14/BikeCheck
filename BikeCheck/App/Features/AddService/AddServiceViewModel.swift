//
//  AddServiceViewModel.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 22.11.2026.
//

import Foundation

final class AddServiceViewModel {
    
    //MARK: - Public Properties
    var doneAt: Date = .now
    var mileageText = "" {
        didSet {
            validateTextField()
        }
    }
    
    //MARK: - Private Properties
    private let client: NetworkClient
    private let componentId: Int
    private var mileage: Int? {
        Int(mileageText)
    }
    private var isLoading = false
    
    //MARK: - Callbacks
    var onError: ((String) -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onSuccess: (() -> Void)?
    var onCreateButtonEnabled: ((Bool) -> Void)?
    
    //MARK: - Initializers
    init(client: NetworkClient, componentId: Int) {
        self.client = client
        self.componentId = componentId
    }
    
    //MARK: - Public Methods
    func create() {
        guard let mileage, !isLoading else { return }
        onLoading?(true)
        isLoading = true
        let dateString = DateFormatter.apiDate.string(from: doneAt)
        let newService = NewService(doneAt: dateString, mileageKm: mileage, note: nil)
        Task { [weak self] in
            guard let self else { return }
            defer {
                onLoading?(false)
                isLoading = false
            }
            do {
                try await client.send(ComponentsEndpoint.addService(id: componentId, newService))
                onSuccess?()
            } catch {
                onError?((error as? NetworkError)?.userMessage ?? "Не удалось добавить обслуживание")
            }
        }
    }
    
    //MARK: - Private Methods
    private func validateTextField() {
        guard let mileage, mileage >= 0 else {
            onCreateButtonEnabled?(false)
            return
        }
        onCreateButtonEnabled?(true)
    }
}
