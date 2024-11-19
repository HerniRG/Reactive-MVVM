//
//  LoginViewModel.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 15/11/24.
//

import Combine
import Foundation

enum State {
    case loading
    case showLogin
    case navigateToHeroes
}

@MainActor
final class LoginViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var status: String = ""
    @Published var isLogged: Bool = false
    @Published var state: State = .loading // Estado inicial
    
    // MARK: - Private Properties
    private var authService = AuthService()
    
    // MARK: - Initializer
    init(authService: AuthService = AuthService()) {
        self.authService = authService
        checkToken()
    }
    
    // MARK: - Public Methods
    func login(user: String, password: String) async {
        status = "Haciendo login..."
        state = .loading // Cambiar al estado de carga
        
        do {
            try await authService.login(user: user, password: password)
            handleLoginSuccess()
        } catch {
            handleLoginError(error)
        }
    }
    
    // MARK: - Private Methods
    private func checkToken() {
        if let token = TokenManager.shared.loadToken(), !token.isEmpty {
            print("Token válido encontrado: \(token)")
            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000) // Simulación de espera
                state = .navigateToHeroes
            }
        } else {
            print("No se encontró un token válido")
            state = .showLogin
        }
    }
    
    private func handleLoginSuccess() {
        isLogged = true
        status = "" // Limpia mensajes de error
        state = .navigateToHeroes
    }
    
    private func handleLoginError(_ error: Error) {
        if let authError = error as? AuthenticationError {
            status = authError.localizedDescription
        } else if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                status = "No hay conexión a internet. Por favor, verifica tu red."
            case .timedOut:
                status = "La solicitud ha tardado demasiado. Inténtalo más tarde."
            default:
                status = "Ha ocurrido un error. Intenta nuevamente."
            }
        } else {
            status = "Ha ocurrido un error desconocido."
        }
        state = .showLogin
    }
}
