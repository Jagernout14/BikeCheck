//
//  LoginViewController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 07.11.2026.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: - Private Properties
    private let loginView = LoginView()
    private let viewModel: LoginViewModel
    
    //MARK: - Callbacks
    var onLoginSuccess: (() -> Void)?
    
    // MARK: - Initializers
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - Private Methods
    private func bind() {
        loginView.onEmailChange = { [weak self] text in
            self?.viewModel.email = text
        }
        
        loginView.onPasswordChange = { [weak self] text in
            self?.viewModel.password = text
        }
        
        loginView.onSubmitTap = { [weak self] in
            self?.viewModel.submit()
        }
        
        loginView.onSwitchModeTap = { [weak self] in
            self?.viewModel.toggleMode()
        }
        
        loginView.onConfirmPasswordChange = { [weak self] text in
            self?.viewModel.confirmPassword = text
        }
        
        viewModel.onSuccess = { [weak self] in
            self?.onLoginSuccess?()
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            self?.loginView.setLoading(isLoading)
        }
        
        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
        
        viewModel.onSubmitEnabledChange = { [weak self] isEnabled in
            self?.loginView.setSubmitEnabled(isEnabled)
        }
        
        viewModel.onModeChange = { [weak self] mode in
            self?.loginView.setMode(mode)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
