//
//  MainTabBarController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 07.11.2026.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainTabBar()
        setupAppearance()
    }
    
    private func setupMainTabBar() {
        let garageViewController = UIViewController()
        let serviceHistoryViewController = UIViewController()
        
        garageViewController.view.backgroundColor = .bcBackground
        serviceHistoryViewController.view.backgroundColor = .bcBackground
        
        garageViewController.title = "Гараж"
        serviceHistoryViewController.title = "История обслуживания"
        
        let garageNavigationController = UINavigationController(rootViewController: garageViewController)
        let serviceHistoryNavigationController = UINavigationController(rootViewController: serviceHistoryViewController)
        
        garageNavigationController.tabBarItem = UITabBarItem(title: "Гараж", image: UIImage(systemName: "bicycle"), selectedImage: nil)
        serviceHistoryNavigationController.tabBarItem = UITabBarItem(title: "История", image: UIImage(systemName: "wrench.and.screwdriver"), selectedImage: nil)
        
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
}
