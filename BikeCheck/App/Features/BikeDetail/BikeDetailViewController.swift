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
    private let viewModel: BikeDetailViewModel
    
    // MARK: - Initializers
    init(viewModel: BikeDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override Methods
    override func loadView() {
        view = bikeDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationItem.largeTitleDisplayMode = .never
        bind()
        viewModel.load()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        bikeDetailView.tableView.dataSource = self
        bikeDetailView.tableView.delegate = self
        bikeDetailView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        bikeDetailView.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "BikeDetailHeader")
    }
    
    private func bind() {
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel)
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
        
        viewModel.onLoading = { isLoading in
            print("loading:", isLoading)
        }
        
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            guard let bike = viewModel.bike else { return }
            title = bike.name
            bikeDetailView.configureStats(mileage: "-", weight: formatWeight(bike.totalWeightG))
            bikeDetailView.tableView.reloadData()
        }
    }
    
    private func formatWeight(_ grams: Int?) -> String {
        guard let grams, grams > 0 else { return "" }
        return String(format: "%.1f кг", Double(grams) / 1000)
    }
}

//MARK: - TableViewDataSource
extension BikeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let component = viewModel.components[indexPath.row]
        content.text = component.catalog.category
        content.secondaryText = component.catalog.name
        content.textProperties.color = .bcTextMain
        content.secondaryTextProperties.color = .bcTextSecondary
        cell.contentConfiguration = content
        cell.backgroundColor = .bcCard
        
        return cell
    }
}

//MARK: - TableViewDelegate
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
