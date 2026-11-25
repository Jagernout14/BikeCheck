//
//  HistoryView.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 25.11.2026.
//

import UIKit

final class HistoryView: UIView {
    
    //MARK: - Public Properties
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    //MARK: - Private Properties
    private let placeholder = UILabel()
    
    //MARK: - Callbacks
    //здесь обработчик нажатия на ячейку
    
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(noData: Bool) {
        if noData {
            tableView.backgroundView = placeholder
            placeholder.isHidden = false
        } else {
            placeholder.isHidden = true
        }
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        self.backgroundColor = .bcBackground
        setupTableView()
        setupPlaceholder()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupPlaceholder() {
        placeholder.font = .systemFont(ofSize: 17)
        placeholder.textColor = .bcTextSecondary
        placeholder.text = "Пока нет записей обслуживания"
        placeholder.textAlignment = .center
        placeholder.numberOfLines = 0
        placeholder.isHidden = true
        
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholder)
    }
}
