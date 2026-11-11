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
        let viewModel = GarageViewModel(client: client, selectedBikeStorage: selectedBikeStorage)
        let garageViewController = GarageViewController(viewModel: viewModel)
        let serviceHistoryViewController = UIViewController()
        
        serviceHistoryViewController.view.backgroundColor = .bcBackground
        
        garageViewController.title = "Гараж"
        garageViewController.onLogoutTapped = { [weak self] in
            self?.onLogout?()
        }
        
        serviceHistoryViewController.title = "Сервис"
        
        let garageNavigationController = UINavigationController(rootViewController: garageViewController)
        let serviceHistoryNavigationController = UINavigationController(rootViewController: serviceHistoryViewController)
        
        garageNavigationController.tabBarItem = UITabBarItem(title: "Гараж", image: UIImage(systemName: "bicycle"), selectedImage: nil)
        serviceHistoryNavigationController.tabBarItem = UITabBarItem(title: "Сервис", image: UIImage(systemName: "wrench.and.screwdriver"), selectedImage: nil)
        
        setupNavigationBar(for: garageNavigationController)
        setupNavigationBar(for: serviceHistoryNavigationController)
        viewControllers = [garageNavigationController, serviceHistoryNavigationController]
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
