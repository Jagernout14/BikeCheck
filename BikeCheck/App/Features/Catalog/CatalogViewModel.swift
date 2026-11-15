//
//  CatalogViewModel.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 15.11.2026.
//

import Foundation

final class CatalogViewModel {
    
    // MARK: - Public Properties
    private(set) var catalogItems: [CatalogItem] = []
    private(set) var selectedCategory: ComponentCategory?
    private(set) var searchText: String?
    
    // MARK: - Private Properties
    private let client: NetworkClient
    private var isLoading = false
    private var isInstalling = false
    private let limit = 20
    private var total = 0
    private var loadTask: Task<Void, Never>?
    private let bikeId: Int
    
    //MARK: - Callbacks
    var onError: ((String) -> Void)?
    var onUpdate: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onComponentInstalled: (() -> Void)?
    
    // MARK: - Initializers
    init(client: NetworkClient, bikeId: Int) {
        self.client = client
        self.bikeId = bikeId
    }
    
    // MARK: - Public Methods
    func load() {
        guard catalogItems.isEmpty || catalogItems.count < total else { return }
        guard !isLoading else { return }
        onLoading?(true)
        isLoading = true
        loadTask = Task { [weak self] in
            guard let self else { return }
            defer {
                if !Task.isCancelled {
                    onLoading?(false)
                    isLoading = false
                }
            }
            do {
                let page: Page<CatalogItem> = try await client.request(CatalogEndpoint.list(
                    search: searchText,
                    category: selectedCategory?.rawValue,
                    limit: limit,
                    offset: catalogItems.count)
                )
                guard !Task.isCancelled else { return }
                catalogItems.append(contentsOf: page.items)
                total = page.total
                onUpdate?()
            } catch {
                guard !Task.isCancelled else { return }
                onError?((error as? NetworkError)?.userMessage ?? "Что-то пошло не так")
            }
        }
    }
    
    func installComponent(catalogId: Int) {
        guard !isInstalling else { return }
        onLoading?(true)
        isInstalling = true
        Task { [weak self] in
            guard let self else { return }
            defer {
                onLoading?(false)
                isInstalling = false
            }
            do {
                let newComponent = NewComponent(catalogId: catalogId, installedAt: DateFormatter.apiDate.string(from: Date()), note: nil)
                let _: Component = try await client.request(BikeEndpoint.installComponent(id: bikeId, newComponent))
                onComponentInstalled?()
            } catch {
                onError?((error as? NetworkError)?.userMessage ?? "Что-то пошло не по плану")
            }
        }
    }
    
    func chooseCategory(_ category: ComponentCategory?) {
        selectedCategory = category
        clearAndLoad()
    }
    
    func search(_ text: String) {
        searchText = text.isEmpty ? nil : text
        clearAndLoad()
    }
    
    // MARK: - Private Methods
    private func clearAndLoad() {
        loadTask?.cancel()
        isLoading = false
        catalogItems = []
        total = 0
        load()
    }
}
