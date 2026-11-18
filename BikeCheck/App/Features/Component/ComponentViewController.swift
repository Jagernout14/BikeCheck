//
//  ComponentViewController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 17.11.2026.
//

import UIKit

final class ComponentViewController: UIViewController {
    
    //MARK: - Private Properties
    private let componentView = ComponentView()
    private let viewModel: ComponentViewModel
    
    //MARK: - Callbacks
    var onAddServiceTapped: (() -> Void)?
    
    //MARK: - Initializers
    init(viewModel: ComponentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override Methods
    override func loadView() {
        view = componentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bind()
        viewModel.load()
    }
    
    //MARK: - Private Methods
    private func setupTableView() {
        componentView.tableView.dataSource = self
        componentView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "infoCell")
        componentView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "serviceCell")
    }
    
    private func bind() {
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel)
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
        
        viewModel.onUpdate = { [weak self] in
            self?.componentView.tableView.reloadData()
        }
        
        viewModel.onLoading = { isLoading in
            print("Component is loading: \(isLoading)")
        }
    }
}

//MARK: - TableViewDataSource
extension ComponentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.infoRows.count
        default:
            return viewModel.serviceRows.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
            let row = viewModel.infoRows[indexPath.row]
            var content = UIListContentConfiguration.valueCell()
            content.text = row.text
            content.secondaryText = row.secondaryText
            cell.contentConfiguration = content
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "serviceCell", for: indexPath)
            let row = viewModel.serviceRows[indexPath.row]
            var content = UIListContentConfiguration.subtitleCell()
            content.text = row.text
            content.secondaryText = row.secondaryText
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Информация"
        default:
            return "История обслуживания"
        }
    }
}
