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
    private let viewModel: CatalogViewModel
    private let categories = ComponentCategory.allCases
    
    // MARK: - Initializers
    init(viewModel: CatalogViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func loadView() {
        view = catalogView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableViewAndCollectionView()
        bind()
        viewModel.load()
    }
    
    // MARK: - Actions
    @objc private func tapCancelButton() {
        dismiss(animated: true)
    }
    
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
    
    private func bind() {
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel)
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
        
        viewModel.onLoading = { isLoading in
            print("Loading \(isLoading)")
        }
        
        viewModel.onUpdate = { [weak self] in
            self?.catalogView.tableView.reloadData()
        }
        
        catalogView.onSearch = { [weak self] text in
            self?.viewModel.search(text)
        }
    }
}

//MARK: - TableViewDataSource
extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.catalogItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PartCell.identifier, for: indexPath) as? PartCell else {
            return UITableViewCell()
        }
        let item = viewModel.catalogItems[indexPath.row]
        cell.configure(title: item.name, subtitle: ComponentCategory.title(for: item.category), weight: item.weightG?.gramsText ?? "")
        return cell
    }
}

//MARK: - TableViewDelegate
extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.catalogItems.count - 1 {
            viewModel.load()
        }
    }
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
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false {
            collectionView.deselectItem(at: indexPath, animated: true)
            viewModel.chooseCategory(nil)
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.chooseCategory(categories[indexPath.item])
    }
}
