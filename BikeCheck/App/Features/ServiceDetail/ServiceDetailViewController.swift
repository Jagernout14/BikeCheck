//
//  ServiceDetailViewController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 26.11.2026.
//

import UIKit

final class ServiceDetailViewController: UIViewController {
    
    //MARK: - Private Properties
    private let serviceDetailView = ServiceDetailView()
    private let serviceDetailDisplay: ServiceDetailDisplay
    private var infoRows: [InfoRow] = []
    
    //MARK: - Initializers
    init(serviceDetailDisplay: ServiceDetailDisplay) {
        self.serviceDetailDisplay = serviceDetailDisplay
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override Methods
    override func loadView() {
        view = serviceDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarAndTableView()
        makeRows()
    }
    
    //MARK: - Actions
    @objc private func tapClose() {
        dismiss(animated: true)
    }
    
    //MARK: - Private Methods
    private func setupNavBarAndTableView() {
        title = "Обслуживание"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Закрыть",
            style: .plain,
            target: self,
            action: #selector(tapClose)
        )
        
        serviceDetailView.tableView.dataSource = self
        serviceDetailView.tableView.delegate = self
        
        serviceDetailView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "infoCell")
    }
    
    private func makeRows() {
        infoRows = [
            InfoRow(text: "Компонент", secondaryText: serviceDetailDisplay.componentName),
            InfoRow(text: "Дата", secondaryText: serviceDetailDisplay.dateOfService),
            InfoRow(text: "Пробег", secondaryText: serviceDetailDisplay.mileage)
        ]
        
        if let bikeName = serviceDetailDisplay.bikeName {
            infoRows.insert(InfoRow(text: "Велосипед", secondaryText: bikeName), at: 1)
        }
    }
}

//MARK: - TableViewDataSource
extension ServiceDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return infoRows.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Информация"
        default:
            return "Описание"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
            let row = infoRows[indexPath.row]
            var content = UIListContentConfiguration.valueCell()
            content.text = row.text
            content.secondaryText = row.secondaryText
            cell.backgroundColor = .bcCard
            content.textProperties.color = .bcTextMain
            content.secondaryTextProperties.color = .bcTextSecondary
            cell.contentConfiguration = content
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = serviceDetailDisplay.note ?? "—"
            content.textProperties.color = .bcTextMain
            content.textProperties.numberOfLines = 0
            cell.backgroundColor = .bcCard
            cell.contentConfiguration = content
            return cell
        }
    }
}

//MARK: - TableViewDelegate
extension ServiceDetailViewController: UITableViewDelegate {
    
}

