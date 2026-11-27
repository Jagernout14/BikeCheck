//
//  LoginView.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 07.11.2026.
//

import UIKit

final class LoginView: UIView {
    
    // MARK: - Private Properties
    private let titleLabel = UILabel()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let submitButton = UIButton(type: .system)
    private let switchModeButton = UIButton(type: .system)
    private let stackView = UIStackView()
    private let hintLabel = UILabel()
    private let confirmPasswordField = UITextField()
    private var isSubmitEnabled = false
    
    // MARK: - Callbacks
    var onEmailChange: ((String) -> Void)?
    var onPasswordChange: ((String) -> Void)?
    var onSubmitTap: (() -> Void)?
    var onSwitchModeTap: (() -> Void)?
    var onConfirmPasswordChange: ((String) -> Void)?
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func emailChanged() {
        onEmailChange?(emailField.text ?? "")
    }
    
    @objc private func passwordChanged() {
        onPasswordChange?(passwordField.text ?? "")
    }
    
    @objc private func submitTapped() {
        onSubmitTap?()
    }
    
    @objc private func switchModeTapped() {
        onSwitchModeTap?()
    }
    
    @objc private func confirmPasswordChanged() {
        onConfirmPasswordChange?(confirmPasswordField.text ?? "")
    }
    
    // MARK: - Public Methods
    func setSubmitEnabled(_ isEnabled: Bool) {
        isSubmitEnabled = isEnabled
        submitButton.isEnabled = isEnabled
        submitButton.alpha = isEnabled ? 1 : 0.5
    }
    
    func setMode(_ mode: LoginMode) {
        switch mode {
        case .login:
            hintLabel.isHidden = true
            confirmPasswordField.isHidden = true
            submitButton.setTitle("Войти", for: .normal)
            switchModeButton.setTitle("Зарегистрироваться", for: .normal)
            stackView.setCustomSpacing(24, after: passwordField)
        case .register:
            hintLabel.isHidden = false
            confirmPasswordField.isHidden = false
            submitButton.setTitle("Создать аккаунт", for: .normal)
            switchModeButton.setTitle("Есть аккаунт? Войти", for: .normal)
            stackView.setCustomSpacing(6, after: passwordField)
        }
    }
    
    func setLoading(_ isLoading: Bool) {
        emailField.isEnabled = !isLoading
        passwordField.isEnabled = !isLoading
        confirmPasswordField.isEnabled = !isLoading
        switchModeButton.isEnabled = !isLoading
        
        let canSubmit = !isLoading && isSubmitEnabled
        submitButton.isEnabled = canSubmit
        submitButton.alpha = canSubmit ? 1 : 0.5
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .bcBackground
        setupTitleLabel()
        setupEmailField()
        setupPasswordField()
        setupSubmitButton()
        setupSwitchModeButton()
        setupHintLabel()
        setupConfirmPasswordField()
        setupStackView()
        setupConstraints()
        setupActions()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "BikeCheck"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .bcTextMain
        titleLabel.textAlignment = .center
    }
    
    private func setupHintLabel() {
        hintLabel.text = "Минимум 8 символов"
        hintLabel.font = .systemFont(ofSize: 13)
        hintLabel.textColor = .bcTextSecondary
        hintLabel.numberOfLines = 0
        hintLabel.isHidden = true
    }
    
    private func setupTextFieldStyle(_ textField: UITextField, placeholder: String) {
        textField.backgroundColor = .bcCard
        textField.layer.cornerRadius = 10
        textField.textColor = .bcTextMain
        textField.font = .systemFont(ofSize: 17)
        textField.tintColor = .bcAccent
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.bcTextSecondary]
        )
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
    }
    
    private func setupEmailField() {
        setupTextFieldStyle(emailField, placeholder: "Email")
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.textContentType = .username
    }
    
    private func setupPasswordField() {
        setupTextFieldStyle(passwordField, placeholder: "Пароль")
        passwordField.isSecureTextEntry = true
        passwordField.textContentType = .password
    }
    
    private func setupConfirmPasswordField() {
        setupTextFieldStyle(confirmPasswordField, placeholder: "Повторите пароль")
        confirmPasswordField.isSecureTextEntry = true
        confirmPasswordField.textContentType = .password
        confirmPasswordField.isHidden = true
    }
    
    private func setupSubmitButton() {
        submitButton.setTitle("Войти", for: .normal)
        submitButton.setTitleColor(.bcTextOnAccent, for: .normal)
        submitButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        submitButton.backgroundColor = .bcAccent
        submitButton.layer.cornerRadius = 12
        setSubmitEnabled(false)
    }
    
    private func setupSwitchModeButton() {
        switchModeButton.setTitle("Зарегистрироваться", for: .normal)
        switchModeButton.setTitleColor(.bcAccent, for: .normal)
        switchModeButton.titleLabel?.font = .systemFont(ofSize: 17)
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emailField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(hintLabel)
        stackView.addArrangedSubview(confirmPasswordField)
        stackView.addArrangedSubview(submitButton)
        stackView.addArrangedSubview(switchModeButton)
        
        stackView.spacing = 12
        stackView.setCustomSpacing(32, after: titleLabel)
        stackView.setCustomSpacing(24, after: passwordField)
        stackView.setCustomSpacing(24, after: confirmPasswordField)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            
            emailField.heightAnchor.constraint(equalToConstant: 48),
            confirmPasswordField.heightAnchor.constraint(equalTo: emailField.heightAnchor),
            passwordField.heightAnchor.constraint(equalTo: emailField.heightAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
            switchModeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupActions() {
        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        switchModeButton.addTarget(self, action: #selector(switchModeTapped), for: .touchUpInside)
    }
}
