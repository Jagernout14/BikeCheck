//
//  ServiceCell.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 25.11.2026.
//

import UIKit

final class ServiceCell: UITableViewCell {
    
    //MARK: - Public Properties
    static let identifier = "ServiceCell"
    
    //MARK: - Private Properties
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let noteLabel = UILabel()
    private let stackView = UIStackView()
    
    //MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public methods
    func configure(title: String, subtitle: String, note: String?) {
        noteLabel.isHidden = true
        titleLabel.text = title
        subtitleLabel.text = subtitle
        guard let note, !note.isEmpty else {
            return
        }
        noteLabel.text = note
        noteLabel.isHidden = false
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .bcCard
        setupTitleLabel()
        setupSubtitleLabel()
        setupNoteLabel()
        setupStackView()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .bcTextMain
        titleLabel.numberOfLines = 1
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .bcTextSecondary
        subtitleLabel.numberOfLines = 1
    }
    
    private func setupNoteLabel() {
        noteLabel.font = .systemFont(ofSize: 14)
        noteLabel.textColor = .bcTextSecondary
        noteLabel.numberOfLines = 1
        noteLabel.isHidden = true
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(noteLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
