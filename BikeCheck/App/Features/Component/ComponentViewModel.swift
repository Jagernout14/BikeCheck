//
//  ComponentViewModel.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 17.11.2026.
//

import Foundation

struct ComponentRow {
    let text: String
    let secondaryText: String
}

final class ComponentViewModel {
    
    //MARK: - Public Properties
    private(set) var component: Component?
    private(set) var services: [ServiceRecord] = []
    private(set) var infoRows: [ComponentRow] = []
    private(set) var serviceRows: [ComponentRow] = []
    
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
    
    //MARK: - Private Methods
    private func makeRows() {
        guard let component else { return }
        infoRows = [
            ComponentRow(text: "Вес", secondaryText: component.catalog.weightG?.gramsText ?? "-"),
            ComponentRow(text: "Установлен", secondaryText: makeDisplayDate(from: component.installedAt)),
            ComponentRow(text: "Последнее обслуживание", secondaryText: component.lastServiceAt.map { makeDisplayDate(from: $0) } ?? "-")
        ]
        
        serviceRows = services.map { service in
            ComponentRow(text: "\(service.mileageKm) км", secondaryText: makeDisplayDate(from: service.doneAt))
        }
    }
    
    private func makeDisplayDate(from string: String) -> String {
        guard let date = DateFormatter.apiDate.date(from: string) else {
            return "-"
        }
        let displayDate = DateFormatter.uiDate.string(from: date)
        return displayDate
    }
}
