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
    
    //MARK: - Callbacks
    var onAddTapped: (() -> Void)?
    var onComponentTapped: ((Int) -> Void)?
    var onComponentDeleted: (() -> Void)?
    
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
        setupNavigationBar()
        setupTableView()
        bind()
        viewModel.load()
    }
    
    // MARK: - Actions
    @objc private func tapAddButton() {
        onAddTapped?()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        bikeDetailView.tableView.dataSource = self
        bikeDetailView.tableView.delegate = self
        bikeDetailView.tableView.register(PartCell.self, forCellReuseIdentifier: PartCell.identifier)
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
            bikeDetailView.configureStats(mileage: "-", weight: bike.totalWeightG.kilosText)
            bikeDetailView.tableView.reloadData()
        }
        
        viewModel.onComponentDeleted = { [weak self] in
            self?.onComponentDeleted?()
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(tapAddButton)
        )
    }
}

//MARK: - TableViewDataSource
extension BikeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PartCell.identifier, for: indexPath) as? PartCell else {
            return UITableViewCell()
        }
        
        let component = viewModel.components[indexPath.row]
        cell.configure(title: component.catalog.name, subtitle: ComponentCategory.title(for: component.catalog.category), weight: component.catalog.weightG?.gramsText ?? "")
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let component = viewModel.components[indexPath.row]
        onComponentTapped?(component.id)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { action, view, completion in
            let component = self.viewModel.components[indexPath.row]
            let alert = UIAlertController(title: nil, message: "Вы действительно хотите удалить \(component.catalog.name)?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                self.viewModel.delete(componentId: component.id)
                completion(true)
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in
                completion(false)
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
