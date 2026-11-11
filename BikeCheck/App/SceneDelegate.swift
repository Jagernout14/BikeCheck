//
//  SceneDelegate.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 31.10.2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var router: AppRouter?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let tokenStorage: TokenStorageProtocol = KeychainTokenStorage()
        let selectedBikeStorage: SelectedBikeStorageProtocol = UserDefaultsSelectedBikeStorage()
        let client = NetworkClient(storage: tokenStorage, decoder: BikeCheckCoding.decoder)
        let router = AppRouter(window: window, tokenStorage: tokenStorage, client: client, selectedBikeStorage: selectedBikeStorage)
        self.window = window
        self.router = router
        router.start()
        window.overrideUserInterfaceStyle = .dark
        window.makeKeyAndVisible()
    }
}
