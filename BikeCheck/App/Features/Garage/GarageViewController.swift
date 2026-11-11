//
//  GarageViewController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 10.11.2026.
//

import UIKit

final class GarageViewController: UIViewController {
    
    // MARK: - Private Properties
    private let garageView = GarageView()
    private let viewModel: GarageViewModel
    
    //MARK: - Callbacks
    var onLogoutTapped: (() -> Void)?
    
    // MARK: - Initializers
    init(viewModel: GarageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func loadView() {
        view = garageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigationBar()
        bind()
        viewModel.load()
    }
    
    // MARK: - Actions
    @objc private func tapLogout() {
        onLogoutTapped?()
    }
    
    @objc private func tapAdd() {
        print("Add button tapped")
    }
    
    //MARK: - Private Methods
    private func setupTableView() {
        garageView.tableView.dataSource = self
        garageView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BikeCell")
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .plain,
            target: self,
            action: #selector(tapLogout)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(tapAdd)
        )
    }
    
    private func bind() {
        viewModel.onLoading = { isLoading in
            print("loading:", isLoading)
        }
        
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            self.garageView.tableView.reloadData()
            if let bike = self.viewModel.selectedBike {
                self.garageView.configureCard(title: bike.name, subtitle: formatWeight(bike.totalWeightG))
            }
        }
        
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel)
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
    }
    
    private func formatWeight(_ grams: Int?) -> String {
        guard let grams, grams > 0 else { return "" }
        return String(format: "%.1f кг", Double(grams) / 1000)
    }
}

//MARK: - TableViewDataSource
extension GarageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.bikes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let bike = viewModel.bikes[indexPath.row]
        content.text = bike.name
        content.secondaryText = formatWeight(bike.totalWeightG)
        content.textProperties.color = .bcTextMain
        content.secondaryTextProperties.color = .bcTextSecondary
        cell.contentConfiguration = content
        cell.backgroundColor = .bcCard
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Мои велосипеды"
    }
}
