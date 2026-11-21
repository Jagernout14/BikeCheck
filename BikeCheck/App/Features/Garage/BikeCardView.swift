//
//  BikeCardView.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 09.11.2026.
//

import UIKit

final class BikeCardView: UIView {
    
    // MARK: - Private Properties
    private let photoImageView = UIImageView()
    private let placeholderStack = UIStackView()
    private let placeholderIcon = UIImageView()
    private let placeholderLabel = UILabel()
    private let bottomBar = UIView()
    private let textStack = UIStackView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let chevronImageView = UIImageView()
    
    //MARK: - Callbacks
    var onBikeCardTapped: (() -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func cardTapped() {
        onBikeCardTapped?()
    }
    
    // MARK: - Public Methods
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        setupView()
        setupPhotoImageView()
        setupPlaceholder()
        setupBottomBar()
        setupViewsHierarchy()
        setupConstraints()
        setupGesture()
    }
    
    private func setupView() {
        self.backgroundColor = .bcPhotoBackground
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    private func setupPhotoImageView() {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupPlaceholder() {
        placeholderIcon.image = UIImage(systemName: "bicycle")
        placeholderIcon.tintColor = .bcIconMuted
        placeholderIcon.contentMode = .scaleAspectFit
        
        placeholderLabel.font = .systemFont(ofSize: 13)
        placeholderLabel.text = "Фото велосипеда"
        placeholderLabel.textColor = .bcIconMuted
        
        placeholderStack.axis = .vertical
        placeholderStack.alignment = .center
        placeholderStack.spacing = 8
        
        placeholderStack.addArrangedSubview(placeholderIcon)
        placeholderStack.addArrangedSubview(placeholderLabel)
        placeholderStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupBottomBar() {
        bottomBar.backgroundColor = .bcPhotoBar
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .bcTextMain
        
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .bcTextSecondary
        
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(subtitleLabel)
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = .bcIconMuted
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupViewsHierarchy() {
        addSubview(photoImageView)
        addSubview(placeholderStack)
        addSubview(bottomBar)
        bottomBar.addSubview(textStack)
        bottomBar.addSubview(chevronImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            placeholderStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderStack.topAnchor.constraint(equalTo: topAnchor, constant: 46),
            
            placeholderIcon.widthAnchor.constraint(equalToConstant: 88),
            placeholderIcon.heightAnchor.constraint(equalTo: placeholderIcon.widthAnchor),
            
            bottomBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textStack.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 18),
            textStack.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 14),
            textStack.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -14),
            
            chevronImageView.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -18),
            chevronImageView.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalTo: chevronImageView.widthAnchor),
            
            photoImageView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor),
            textStack.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8)
        ])
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tap)
    }
}
