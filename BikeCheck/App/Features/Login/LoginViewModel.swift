//
//  LoginViewModel.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 06.11.2026.
//

final class LoginViewModel {
    
    // MARK: - Public Properties
    private(set) var mode: LoginMode = .login
    
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
    
    var confirmPassword = "" {
        didSet {
            validateForm()
        }
    }
    
    // MARK: - Private Properties
    private let client: NetworkClient
    private let tokenStorage: TokenStorageProtocol
    private var isLoading = false
    
    // MARK: - Callbacks
    var onModeChange: ((LoginMode) -> Void)?
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
    
    func toggleMode() {
        confirmPassword = ""
        mode = mode == .login ? .register : .login
        onModeChange?(mode)
        validateForm()
    }
    
    // MARK: - Private Methods
    private func validateForm() {
        let isValid: Bool
        
        switch mode {
        case .login:
            isValid = !email.isEmpty && !password.isEmpty
        case .register:
            isValid = email.contains("@") && password.count >= 8 && password == confirmPassword
        }
        
        onLoginEnabledChange?(isValid)
    }
}
