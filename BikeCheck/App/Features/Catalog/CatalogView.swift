//
//  CatalogView.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 13.11.2026.
//

import UIKit

final class CatalogView: UIView {
    
    // MARK: - Public Properties
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Private Properties
    private let searchField = UITextField()
    private let addButton = UIButton(type: .system)
    
    //MARK: - Callbacks
    var onAddButtonTap: (() -> Void)?
    var onSearch: ((String) -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func tapButton() {
        onAddButtonTap?()
    }
    
    @objc private func searchSubmitted() {
        onSearch?(searchField.text ?? "")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        self.backgroundColor = .bcBackground
        setupSearchField()
        setupCollectionView()
        setupTableView()
        setupButton()
        setupConstraints()
    }
    
    private func setupSearchField() {
        let spacingView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 16))
        searchField.backgroundColor = .bcCard
        searchField.layer.cornerRadius = 10
        searchField.leftView = spacingView
        searchField.leftViewMode = .always
        searchField.font = .systemFont(ofSize: 17)
        searchField.textColor = .bcTextMain
        searchField.attributedPlaceholder = NSAttributedString(string: "Поиск детали", attributes: [.foregroundColor: UIColor.bcTextSecondary])
        searchField.clearButtonMode = .whileEditing
        searchField.returnKeyType = .search
        searchField.autocorrectionType = .no
        searchField.addTarget(self, action: #selector(searchSubmitted), for: .editingDidEndOnExit)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(searchField)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
    }
    
    private func setupButton() {
        addButton.setTitle("Нет в списке? Добавить свою деталь", for: .normal)
        addButton.setTitleColor(.bcAccent, for: .normal)
        addButton.titleLabel?.font = .systemFont(ofSize: 17)
        addButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(addButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchField.heightAnchor.constraint(equalToConstant: 48),
            searchField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            searchField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            collectionView.heightAnchor.constraint(equalToConstant: 34),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 4),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            addButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}
