//
//  CatalogViewController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 15.11.2026.
//

import UIKit

final class CatalogViewController: UIViewController {
    
    // MARK: - Private Properties
    private let catalogView = CatalogView()
    //private let viewModel: CatalogViewModel
    private let categories = ComponentCategory.allCases
    
    //MARK: - Mock Data
    private let mockParts: [(title: String, subtitle: String, weight: String)] = [
        ("RockShox ZEB Ultimate", "Вилка", "2 400 г"),
        ("Shimano XT M8100", "Трансмиссия", "1 150 г"),
        ("DT Swiss 350 Boost", "Втулки", "410 г"),
        ("SRAM Code RSC", "Тормоза", "590 г"),
        ("Race Face Atlas 35", "Кокпит", "320 г"),
        ("Cane Creek 40", "Рулевая", "105 г"),
        ("Fox Float X2", "Амортизация", "590 г"),
        ("DT Swiss EX 511", "Обода", "560 г")
    ]
    
    // MARK: - Initializers
    
    // MARK: - Overrides Methods
    override func loadView() {
        view = catalogView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableViewAndCollectionView()
    }
    
    // MARK: - Actions
    @objc private func tapCancelButton() {
        dismiss(animated: true)
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    private func setupTableViewAndCollectionView() {
        catalogView.tableView.dataSource = self
        catalogView.tableView.delegate = self
        catalogView.tableView.register(PartCell.self, forCellReuseIdentifier: PartCell.identifier)
        
        catalogView.collectionView.dataSource = self
        catalogView.collectionView.delegate = self
        catalogView.collectionView.register(ChipCell.self, forCellWithReuseIdentifier: ChipCell.identifier)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(tapCancelButton)
        )
        title = "Каталог"
    }
}

//MARK: - TableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mockParts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PartCell.identifier, for: indexPath) as? PartCell else {
            return UITableViewCell()
        }
        cell.configure(title: mockParts[indexPath.row].title, subtitle: mockParts[indexPath.row].subtitle, weight: mockParts[indexPath.row].weight)
        return cell
    }
}

//MARK: - TableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    
}

//MARK: - CollectionViewDataSource
extension CatalogViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChipCell.identifier, for: indexPath) as? ChipCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(text: categories[indexPath.item].title)
        return cell
    }
}

//MARK: - CollectionViewDelegate
extension CatalogViewController: UICollectionViewDelegate {
    
}
