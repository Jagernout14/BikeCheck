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
    private let client: NetworkClient
    
    // MARK: - Initializers
    init(window: UIWindow, tokenStorage: TokenStorageProtocol, client: NetworkClient) {
        self.window = window
        self.tokenStorage = tokenStorage
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
        let tabBar = MainTabBarController(client: client)
        setRoot(tabBar)
    }
    
    private func setRoot(_ viewController: UIViewController) {
        window.rootViewController = viewController
        //TODO: - не забыть добавить анимацию
    }
    
}
