//
//  AppRouter.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 08.11.2026.
//

import UIKit

final class AppRouter {
    
    // MARK: - Private Properties
    private let window: UIWindow
    private let tokenStorage: TokenStorageProtocol
    private let selectedBikeStorage: SelectedBikeStorageProtocol
    private let client: NetworkClient
    
    // MARK: - Initializers
    init(window: UIWindow, tokenStorage: TokenStorageProtocol, client: NetworkClient, selectedBikeStorage: SelectedBikeStorageProtocol) {
        self.window = window
        self.tokenStorage = tokenStorage
        self.selectedBikeStorage = selectedBikeStorage
        self.client = client
    }
    
    // MARK: - Public Methods
    func start() {
        if tokenStorage.token != nil {
            showMain()
        } else {
            showLogin()
        }
    }
    
    // MARK: - Private Methods
    private func showLogin() {
        let viewModel = LoginViewModel(client: client, tokenStorage: tokenStorage)
        let viewController = LoginViewController(viewModel: viewModel)
        viewController.onLoginSuccess = { [weak self] in
            self?.showMain()
        }
        setRoot(viewController)
    }
    
    private func showMain() {
        let tabBar = MainTabBarController(client: client, selectedBikeStorage: selectedBikeStorage)
        tabBar.onLogout = { [weak self] in
            guard let self else { return }
            do {
                try self.tokenStorage.clear()
            } catch {
                print(error.localizedDescription)
            }
            self.selectedBikeStorage.clear()
            self.showLogin()
        }
        setRoot(tabBar)
    }
    
    private func setRoot(_ viewController: UIViewController) {
        window.rootViewController = viewController
        //TODO: - не забыть добавить анимацию
    }
}
