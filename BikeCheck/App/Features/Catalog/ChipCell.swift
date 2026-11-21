//
//  ChipCell.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 15.11.2026.
//

import UIKit

final class ChipCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let identifier = "ChipCell"
    
    // MARK: - Private Properties
    private let label = UILabel()
    
    override var isSelected: Bool {
        didSet {
            self.backgroundColor = isSelected ? .bcAccent : .bcCard
            label.textColor = isSelected ? .bcTextOnAccent : .bcTextMain
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChipCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(text: String) {
        label.text = text
    }
    
    // MARK: - Private Methods
    private func setupChipCell() {
        self.backgroundColor = .bcCard
        self.layer.cornerRadius = 17
        label.font = .systemFont(ofSize: 15)
        label.textColor = .bcTextMain
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 34),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14)
        ])
    }
}
