//
//  BikeStatsView.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 11.11.2026.
//

import UIKit

final class BikeStatsView: UIView {
    
    //MARK: - Private Properties
    private let mileageLabel = UILabel()
    private let weightLabel = UILabel()
    
    private let mileageValueLabel = UILabel()
    private let weightValueLabel = UILabel()
    
    private let mileageStackView = UIStackView()
    private let weightStackView = UIStackView()
    private let mainStackView = UIStackView()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(mileage: String, weight: String) {
        mileageValueLabel.text = mileage
        weightValueLabel.text = weight
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        setupView()
        setupTitleLabel(mileageLabel, text: "Пробег")
        setupTitleLabel(weightLabel, text: "Общий вес")
        setupValueLabel(mileageValueLabel)
        setupValueLabel(weightValueLabel)
        setupColumn(mileageStackView, title: mileageLabel, value: mileageValueLabel)
        setupColumn(weightStackView, title: weightLabel, value: weightValueLabel)
        setupMainStackView()
        setupConstraints()
    }
    
    private func setupView() {
        self.backgroundColor = .bcCard
        self.layer.cornerRadius = 12
    }
    
    private func setupTitleLabel(_ label: UILabel, text: String) {
        label.font = .systemFont(ofSize: 13)
        label.textColor = .bcTextSecondary
        label.text = text
    }
    
    private func setupValueLabel(_ label: UILabel) {
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .bcTextMain
        
    }
    
    private func setupColumn(_ stack: UIStackView, title: UILabel, value: UILabel) {
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(value)
    }
    
    private func setupMainStackView() {
        mainStackView.axis = .horizontal
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 16
        mainStackView.addArrangedSubview(mileageStackView)
        mainStackView.addArrangedSubview(weightStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 14),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14)
        ])
    }
}
