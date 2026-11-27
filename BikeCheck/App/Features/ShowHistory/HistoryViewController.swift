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
    
    //MARK: - Callbacks
    var onServiceTapped: ((ServiceDetailDisplay) -> Void)?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshServices()
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
            self.historyView.setupView(isVisible: viewModel.services.isEmpty)
        }
    }
    
    private func setupNavBarAndTableView() {
        title = "История"
        historyView.tableView.register(ServiceCell.self, forCellReuseIdentifier: ServiceCell.identifier)
        historyView.tableView.dataSource = self
        historyView.tableView.delegate = self
    }
}

//MARK: - TableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ServiceCell.identifier) as? ServiceCell else {
            return UITableViewCell()
        }
        
        let item = viewModel.services[indexPath.row]
        let date = DateFormatter.makeDateString(from: item.doneAt)
        
        cell.configure(title: "\(item.componentName) · \(item.bikeName)", subtitle: "\(date) · \(item.mileageKm) км", note: item.note)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

//MARK: - TableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.services.count - 1 {
            viewModel.load()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let serviceDisplay = viewModel.makeServiceDetailDisplay(at: indexPath.row)
        onServiceTapped?(serviceDisplay)
    }
}
