//
//  GarageViewController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 10.11.2026.
//

import UIKit

final class GarageViewController: UIViewController {
    
    //MARK: - Mock bikes
    private let bikes = ["Commencal Meta TR", "Santa Cruz V10", "Canyon Spectral", "YT Capra"]
    
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
        garageView.configureCard(title: bikes[0], subtitle: "Enduro 15.4 кг")
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
}

//MARK: - TableViewDataSource
extension GarageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bikes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = bikes[indexPath.row]
        content.textProperties.color = .bcTextMain
        cell.contentConfiguration = content
        cell.backgroundColor = .bcCard
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Мои велосипеды"
    }
}
