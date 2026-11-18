//
//  MainTabBarController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 07.11.2026.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Private Properties
    private let client: NetworkClient
    private let selectedBikeStorage: SelectedBikeStorageProtocol
    
    //MARK: - Callbacks
    var onLogout: (() -> Void)?
    
    // MARK: - Initializers
    init(client: NetworkClient, selectedBikeStorage: SelectedBikeStorageProtocol) {
        self.client = client
        self.selectedBikeStorage = selectedBikeStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainTabBar()
        setupAppearance()
    }
    
    // MARK: - Private Methods
    private func setupMainTabBar() {
        let garageViewModel = GarageViewModel(client: client, selectedBikeStorage: selectedBikeStorage)
        let garageViewController = GarageViewController(viewModel: garageViewModel)
        let garageNavigationController = UINavigationController(rootViewController: garageViewController)
        garageViewController.title = "Гараж"
        garageNavigationController.tabBarItem = UITabBarItem(
            title: "Гараж",
            image: UIImage(systemName: "bicycle"),
            selectedImage: nil
        )
        setupNavigationBar(for: garageNavigationController)
        
        garageViewController.onLogoutTapped = { [weak self] in
            self?.onLogout?()
        }
        
        garageViewController.onBikeDetailTapped = { [weak self, weak garageNavigationController] bikeId in
            guard let self, let garageNavigationController else { return }
            openBikeDetailScreen(bikeId: bikeId, navigationController: garageNavigationController)
        }
        
        let serviceViewController = MockServiceViewController()
        let serviceNavigationController = UINavigationController(rootViewController: serviceViewController)
        serviceViewController.title = "Сервис"
        serviceNavigationController.tabBarItem = UITabBarItem(
            title: "Сервис",
            image: UIImage(systemName: "wrench.and.screwdriver"),
            selectedImage: nil
        )
        setupNavigationBar(for: serviceNavigationController)
        
        viewControllers = [garageNavigationController, serviceNavigationController]
    }
    
    private func openBikeDetailScreen(bikeId: Int, navigationController: UINavigationController) {
        let bikeViewModel = BikeDetailViewModel(client: client, bikeId: bikeId)
        let bikeViewController = BikeDetailViewController(viewModel: bikeViewModel)
        bikeViewController.onAddTapped = { [weak self, weak bikeViewController] in
            guard let self, let bikeViewController else { return }
            openCatalogScreen(bikeId: bikeId, source: bikeViewController) {
                bikeViewModel.load()
            }
        }
        
        bikeViewController.onComponentTapped = { [weak self, weak navigationController] componentId in
            guard let self, let navigationController else { return }
            openComponentScreen(componentId: componentId, navigationController: navigationController)
            
        }
        navigationController.pushViewController(bikeViewController, animated: true)
    }
    
    private func openCatalogScreen(bikeId: Int, source: UIViewController, onInstalled: @escaping () -> Void) {
        let catalogViewModel = CatalogViewModel(client: client, bikeId: bikeId)
        let catalogViewController = CatalogViewController(viewModel: catalogViewModel)
        let catalogNavigationController = UINavigationController(rootViewController: catalogViewController)
        setupNavigationBar(for: catalogNavigationController)
        catalogViewController.onInstalledComponent = { [weak source] in
            source?.dismiss(animated: true)
            onInstalled()
        }
        source.present(catalogNavigationController, animated: true)
    }
    
    private func openComponentScreen(componentId: Int, navigationController: UINavigationController) {
        let componentViewModel = ComponentViewModel(client: client, componentId: componentId)
        let componentViewController = ComponentViewController(viewModel: componentViewModel)
        navigationController.pushViewController(componentViewController, animated: true)
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .bcBackground
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.tintColor = .bcAccent
        tabBar.unselectedItemTintColor = .bcTextSecondary
    }
    
    private func setupNavigationBar(for navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .bcBackground
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.bcTextMain]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.bcTextMain]
        
        let navigationBar = navigationController.navigationBar
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .bcAccent
        navigationBar.prefersLargeTitles = true
    }
}
