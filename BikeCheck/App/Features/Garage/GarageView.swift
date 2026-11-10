//
//  GarageView.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 09.11.2026.
//

import UIKit

final class GarageView: UIView {
    
    // MARK: - Public Properties
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Private Properties
    private let bikeCard = BikeCardView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configureCard(title: String, subtitle: String) {
        bikeCard.configure(title: title, subtitle: subtitle)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        self.backgroundColor = .bcBackground
        setupBikeCard()
        setupTableView()
    }
    
    private func setupBikeCard() {
        bikeCard.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(bikeCard)
        
        NSLayoutConstraint.activate([
            bikeCard.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            bikeCard.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            bikeCard.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            bikeCard.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func setupTableView() {
        tableView.rowHeight = 64
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: bikeCard.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
