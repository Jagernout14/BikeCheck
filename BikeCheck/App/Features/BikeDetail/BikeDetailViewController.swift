//
//  BikeDetailViewController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 12.11.2026.
//

import UIKit

final class BikeDetailViewController: UIViewController {
    
    // MARK: - Private Properties
    private let bikeDetailView = BikeDetailView()
    //private let viewModel: BikeDetailViewModel
    
    //MARK: - Mock Data
    // Карточка статистики
    private let mockBikeName = "Commencal Supreme DH"
    private let mockWeight = "17.8 кг"
    private let mockMileage = "1 240 км"
    
    // Компоненты
    private let mockComponents: [(name: String, detail: String)] = [
        ("Рама", "Commencal Supreme DH V5 · 4.9 кг"),
        ("Вилка", "Fox 40 Factory · 2.8 кг"),
        ("Амортизатор", "Fox DHX2 · 0.9 кг"),
        ("Колёса", "DT Swiss FR1500 · 2.3 кг"),
        ("Трансмиссия", "Shimano Saint M820 · 1.1 кг"),
        ("Рулевая", "Chris King DropSet · 0.1 кг")
    ]
    
    // MARK: - Initializers
    
    //MARK: - Override Methods
    override func loadView() {
        view = bikeDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        title = mockBikeName
        navigationItem.largeTitleDisplayMode = .never
        bikeDetailView.configureStats(mileage: mockMileage, weight: mockWeight)
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func setupTableView() {
        bikeDetailView.tableView.dataSource = self
        bikeDetailView.tableView.delegate = self
        bikeDetailView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        bikeDetailView.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "BikeDetailHeader")
    }
}

//MARK: - TableViewDataSource
extension BikeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockComponents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let component = mockComponents[indexPath.row]
        content.text = component.name
        content.secondaryText = component.detail
        content.textProperties.color = .bcTextMain
        content.secondaryTextProperties.color = .bcTextSecondary
        cell.contentConfiguration = content
        cell.backgroundColor = .bcCard
        
        return cell
    }
}

extension BikeDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BikeDetailHeader") else {
            return nil
        }
        
        var content = header.defaultContentConfiguration()
        content.text = "Компоненты".uppercased()
        content.textProperties.font = .systemFont(ofSize: 13, weight: .semibold)
        content.textProperties.color = .bcTextSecondary
        header.contentConfiguration = content
        return header
    }
}
