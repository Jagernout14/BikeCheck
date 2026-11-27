//
//  ComponentViewModel.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 17.11.2026.
//

import Foundation

struct InfoRow {
    let text: String
    let secondaryText: String
}

struct ServiceRow {
    let text: String
    let secondaryText: String
    let note: String?
}

final class ComponentViewModel {
    
    //MARK: - Public Properties
    private(set) var component: Component?
    private(set) var services: [ServiceRecord] = []
    private(set) var infoRows: [InfoRow] = []
    private(set) var serviceRows: [ServiceRow] = []
    
    var screenTitle: String {
        component?.catalog.name ?? ""
        
    }
    
    //MARK: - Private Properties
    private let client: NetworkClient
    private let componentId: Int
    
    //MARK: - Callbacks
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onUpdate: (() -> Void)?
    
    //MARK: - Initializers
    init(client: NetworkClient, componentId: Int) {
        self.client = client
        self.componentId = componentId
    }
    
    //MARK: - Public Methods
    func load() {
        onLoading?(true)
        Task { [weak self] in
            guard let self else { return }
            defer { onLoading?(false) }
            do {
                async let info: Component = client.request(ComponentsEndpoint.get(id: componentId))
                async let service: [ServiceRecord] = client.request(ComponentsEndpoint.listService(id: componentId))
                let (loadedInfo, loadedService) = try await (info, service)
                component = loadedInfo
                services = loadedService
                makeRows()
                onUpdate?()
            } catch {
                onError?((error as? NetworkError)?.userMessage ?? "Что-то пошло не по плану")
            }
        }
    }
    
    func makeServiceDetailDisplay(at index: Int) -> ServiceDetailDisplay {
        let service = services[index]
        return ServiceDetailDisplay(
            bikeName: nil,
            componentName: screenTitle,
            dateOfService: DateFormatter.makeDateString(from: service.doneAt),
            mileage: "\(service.mileageKm) км",
            note: service.note
        )
    }
    
    //MARK: - Private Methods
    private func makeRows() {
        guard let component else { return }
        infoRows = [
            InfoRow(text: "Вес", secondaryText: component.catalog.weightG?.gramsText ?? "-"),
            InfoRow(text: "Установлен", secondaryText: DateFormatter.makeDateString(from: component.installedAt)),
            InfoRow(text: "Последнее обслуживание", secondaryText: component.lastServiceAt.map { DateFormatter.makeDateString(from: $0) } ?? "-")
        ]
        
        serviceRows = services.map { service in
            ServiceRow(text: "\(service.mileageKm) км", secondaryText: DateFormatter.makeDateString(from: service.doneAt), note: service.note)
        }
    }
}
