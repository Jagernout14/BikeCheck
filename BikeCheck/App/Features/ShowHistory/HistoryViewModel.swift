//
//  HistoryViewModel.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 25.11.2026.
//

import Foundation

final class HistoryViewModel {
    
    //MARK: - Public Properties
    private(set) var services: [ServiceHistoryItem] = []
    
    //MARK: - Private Properties
    private let client: NetworkClient
    
    private var isLoading = false
    private let limit = 20
    private var total = 0
    
    //MARK: - Callbacks
    var onUpdate: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    
    //MARK: - Initializers
    init(client: NetworkClient) {
        self.client = client
    }
    
    //MARK: - Public Methods
    func load() {
        guard services.isEmpty || services.count < total else { return }
        guard !isLoading else { return }
        isLoading = true
        onLoading?(true)
        Task { [weak self] in
            guard let self else { return }
            defer {
                isLoading = false
                onLoading?(false)
            }
            do {
                let page: Page<ServiceHistoryItem> = try await client.request(ServicesEndpoint.list(limit: limit, offset: services.count, bikeId: nil))
                services.append(contentsOf: page.items)
                total = page.total
                onUpdate?()
            } catch {
                onError?((error as? NetworkError)?.userMessage ?? "Не удалось загрузить историю")
            }
        }
    }
    
    func refreshServices() {
        services = []
        total = 0
        load()
    }
    
    func makeServiceDetailDisplay(at index: Int) -> ServiceDetailDisplay {
        let item = services[index]
        return ServiceDetailDisplay(
            bikeName: item.bikeName,
            componentName: item.componentName,
            dateOfService: DateFormatter.makeDateString(from: item.doneAt),
            mileage: "\(item.mileageKm) км",
            note: item.note
        )
    }
}
