//
//  BikeDetailView.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 11.11.2026.
//

import UIKit

final class BikeDetailView: UIView {
    
    // MARK: - Public Properties
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Private Properties
    private let statsView = BikeStatsView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configureStats(mileage: String, weight: String) {
        statsView.configure(mileage: mileage, weight: weight)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        setupView()
        setupStatsView()
        setupTableView()
        setupConstraints()
    }
    
    private func setupView() {
        self.backgroundColor = .bcBackground
    }
    
    private func setupStatsView() {
        statsView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(statsView)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            statsView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            statsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
}
