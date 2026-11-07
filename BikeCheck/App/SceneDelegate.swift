//
//  SceneDelegate.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 31.10.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let tokenStorage = KeychainTokenStorage()
        let client = NetworkClient(storage: tokenStorage, decoder: BikeCheckCoding.decoder)
        let viewModel = LoginViewModel(client: client, tokenStorage: tokenStorage)
        let loginViewController = LoginViewController(viewModel: viewModel)
        window.rootViewController = loginViewController
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
