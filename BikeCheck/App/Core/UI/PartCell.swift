//
//  PartCell.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 13.11.2026.
//

import UIKit

final class PartCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let identifier = "PartCell"
    
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let weightLabel = UILabel()
    private let chevronImageView = UIImageView()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(title: String, subtitle: String, weight: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        weightLabel.text = weight
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        self.backgroundColor = .bcCard
        setupTitleLabel()
        setupSubtitleLabel()
        setupWeightLabel()
        setupChevronImageView()
        setupConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .bcTextMain
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .bcTextSecondary
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
    }
    
    private func setupWeightLabel() {
        weightLabel.font = .systemFont(ofSize: 17)
        weightLabel.textColor = .bcTextSecondary
        weightLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        weightLabel.setContentHuggingPriority(.required, for: .horizontal)
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(weightLabel)
    }
    
    private func setupChevronImageView() {
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .bcIconMuted
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(chevronImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: weightLabel.leadingAnchor, constant: -12),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalTo: chevronImageView.widthAnchor),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            weightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weightLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -12),
            weightLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 12),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56)
        ])
    }
}
