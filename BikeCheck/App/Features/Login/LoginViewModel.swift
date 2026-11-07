//
//  LoginViewModel.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 06.11.2026.
//

import Foundation

@MainActor
final class LoginViewModel {
    
    // MARK: - Public Properties
    var email = "" {
        didSet {
            validateForm()
        }
    }
    
    var password = "" {
        didSet {
            validateForm()
        }
    }
    
    // MARK: - Private Properties
    private let client: NetworkClient
    private let tokenStorage: TokenStorageProtocol
    private var isLoading = false
    
    // MARK: - Callbacks
    var onSuccess: (() -> Void)?
    var onLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onLoginEnabledChange: ((Bool) -> Void)?
    
    // MARK: - Initializers
    init(client: NetworkClient, tokenStorage: TokenStorageProtocol) {
        self.client = client
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - Public Methods
    func login() {
        guard !isLoading else { return }
        isLoading = true
        onLoading?(true)
        Task { [weak self] in
            guard let self else { return }
            defer {
                isLoading = false
                onLoading?(false)
            }
            do {
                let loginResponse: AuthResponse = try await client.request(AuthEndpoint.login(Credentials(email: email, password: password)))
                try tokenStorage.save(loginResponse.accessToken)
                onSuccess?()
            } catch NetworkError.serverError(statusCode: 401, _) {
                onError?("Неверный email или пароль")
            } catch {
                onError?((error as? NetworkError)?.userMessage ?? "Войти не удалось. Попробуйте еще раз")
            }
        }
    }
    
    // MARK: - Private Methods
    private func validateForm() {
        let isValid = !email.isEmpty && !password.isEmpty
        onLoginEnabledChange?(isValid)
    }
}
