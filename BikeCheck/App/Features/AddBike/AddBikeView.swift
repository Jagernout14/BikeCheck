//
//  AddBikeView.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 19.11.2026.
//

import UIKit

final class AddBikeView: UIView {
    
    //MARK: - Private Properties
    private let titleLabel = UILabel()
    private let nameTextField = UITextField()
    private let createButton = UIButton(type: .system)
    
    //MARK: - Callbacks
    var onNameChange: ((String) -> Void)?
    var onCreateTapped: (() -> Void)?
    
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc private func tapCreateButton() {
        onCreateTapped?()
    }
    
    @objc private func nameChanged() {
        onNameChange?(nameTextField.text ?? "")
    }
    
    //MARK: - Public Methods
    func setCreateButtonEnabled(isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        createButton.alpha = isEnabled ? 1 : 0.5
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        self.backgroundColor = .bcBackground
        setupTitleLabel()
        setupNameTextField()
        setupCreateButton()
        
    }
    
    private func setupTitleLabel() {
        titleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        titleLabel.textColor = .bcTextSecondary
        titleLabel.text = "Название".uppercased()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
        ])
    }
    
    private func setupNameTextField() {
        nameTextField.backgroundColor = .bcCard
        nameTextField.layer.cornerRadius = 10
        nameTextField.clipsToBounds = true
        nameTextField.font = .systemFont(ofSize: 17)
        nameTextField.textColor = .bcTextMain
        nameTextField.tintColor = .bcAccent
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Название велосипеда", attributes: [.foregroundColor: UIColor.bcTextSecondary])
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        nameTextField.leftViewMode = .always
        nameTextField.autocapitalizationType = .sentences
        nameTextField.autocorrectionType = .no
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.returnKeyType = .done
        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        nameTextField.delegate = self
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupCreateButton() {
        createButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        createButton.setTitle("Сохранить", for: .normal)
        createButton.setTitleColor(.bcTextOnAccent, for: .normal)
        createButton.backgroundColor = .bcAccent
        createButton.layer.cornerRadius = 12
        createButton.clipsToBounds = true
        setCreateButtonEnabled(isEnabled: false)
        createButton.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(createButton)
        
        NSLayoutConstraint.activate([
            createButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -8)
        ])
    }
}

//MARK: - UITextFieldDelegate
extension AddBikeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
