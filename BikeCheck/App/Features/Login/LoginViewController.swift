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
        
        loginView.onLoginTap = { [weak self] in
            self?.viewModel.login()
        }
        
        loginView.onRegisterTap = {
            print("Registration tapped")
        }
        
        viewModel.onSuccess = {
            print("Login success")
        }
        
        viewModel.onLoading = { [weak self] isLoading in
            self?.loginView.setLoading(isLoading)
        }
        
        viewModel.onError = { [weak self] message in
            self?.showError(message)
        }
        
        viewModel.onLoginEnabledChange = { [weak self] isEnabled in
            self?.loginView.setLoginEnabled(isEnabled)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
        
    }
}
