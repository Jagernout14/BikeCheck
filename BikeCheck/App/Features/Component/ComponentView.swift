//
//  ComponentView.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 17.11.2026.
//

import UIKit

final class ComponentView: UIView {
    
    // MARK: - Public Properties
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Private Properties
    private let addServiceButton = UIButton(type: .system)
    
    //MARK: - Callbacks
    var onAddTapped: (() -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func tapAddServiceButton() {
        onAddTapped?()
    }
    
    //MARK: - Public Methods
    
    //MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .bcBackground
        setupAddServiceButton()
        setupTableView()
    }
    
    private func setupAddServiceButton() {
        addServiceButton.setTitle("Добавить обслуживание", for: .normal)
        addServiceButton.setTitleColor(.bcTextOnAccent, for: .normal)
        addServiceButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        addServiceButton.backgroundColor = .bcAccent
        addServiceButton.addTarget(self, action: #selector(tapAddServiceButton), for: .touchUpInside)
        addServiceButton.layer.cornerRadius = 12
        addServiceButton.clipsToBounds = true
        addServiceButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addServiceButton)
        
        NSLayoutConstraint.activate([
            addServiceButton.heightAnchor.constraint(equalToConstant: 50),
            addServiceButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addServiceButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addServiceButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: addServiceButton.topAnchor, constant: -8)
        ])
    }
}
