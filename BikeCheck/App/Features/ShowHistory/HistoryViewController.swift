//
//  HistoryViewController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 25.11.2026.
//

import UIKit

final class HistoryViewController: UIViewController {
    
    //MARK: - Private Properties
    private let historyView = HistoryView()
    private let viewModel: HistoryViewModel
    
    //MARK: - Initializers
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override Methods
    override func loadView() {
        view = historyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupNavBarAndTableView()
        viewModel.load()
        
    }
    
    //MARK: - Private Methods
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
            guard let self else { return }
            self.historyView.tableView.reloadData()
            self.historyView.setupView(noData: viewModel.services.isEmpty)
        }
    }
    
    private func setupNavBarAndTableView() {
        title = "История"
        historyView.tableView.register(ServiceCell.self, forCellReuseIdentifier: ServiceCell.identifier)
        historyView.tableView.dataSource = self
        historyView.tableView.delegate = self
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceCell.identifier) as? ServiceCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.services[indexPath.row]
        
        cell.configure(title: "\(item.componentName) · \(item.bikeName)", subtitle: "\(item.doneAt) · \(item.mileageKm) км", note: item.note)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    
}
