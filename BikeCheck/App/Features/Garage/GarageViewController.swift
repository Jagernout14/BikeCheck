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
    var onBikeDetailTapped: ((Int) -> Void)?
    
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
        
    }
    
    //MARK: - Private Methods
    private func setupTableView() {
        garageView.tableView.dataSource = self
        garageView.tableView.delegate = self
        garageView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BikeCell")
        garageView.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "BikeHeader")
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
            
            UIView.transition(with: garageView.tableView, duration: 0.25, options: .transitionCrossDissolve) {
                self.garageView.tableView.reloadData()
            }
            
            if let bike = viewModel.selectedBike {
                UIView.transition(with: garageView, duration: 0.25, options: .transitionCrossDissolve) {
                    self.garageView.configureCard(title: bike.name, subtitle: bike.totalWeightG.kilosText)
                }
            }
        }
        
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel)
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
        
        garageView.onCardTapped = { [weak self] in
            guard let self, let bikeId = viewModel.selectedBike?.id else { return }
            onBikeDetailTapped?(bikeId)
        }
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
        let isSelected = bike.id == viewModel.selectedBike?.id
        content.text = bike.name
        content.secondaryText = bike.totalWeightG.kilosText
        content.textProperties.color = .bcTextMain
        content.secondaryTextProperties.color = .bcTextSecondary
        cell.contentConfiguration = content
        cell.backgroundColor = isSelected ? .bcSelected : .bcCard
        return cell
    }
}

//MARK: - TableViewDelegate
extension GarageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectBike(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "BikeHeader") else {
            return nil
        }
        
        var content = header.defaultContentConfiguration()
        content.text = "Мои велосипеды".uppercased()
        content.textProperties.font = .systemFont(ofSize: 13, weight: .semibold)
        content.textProperties.color = .bcTextSecondary
        header.contentConfiguration = content
        return header
    }
}
