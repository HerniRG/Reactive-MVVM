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

final class LoginViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var status: String = ""
    @Published var isLogged: Bool = false
    @Published var state: State = .loading // Estado inicial
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let authService = AuthService() // Servicio de autenticación
    
    // MARK: - Initializer
    init() {
        checkToken() // Verifica el token al inicializar
    }
    
    // MARK: - Public Methods
    func login(user: String, password: String) {
        status = "Haciendo login..."
        state = .loading // Cambiar al estado de carga
        
        authService.login(user: user, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.handleLoginError(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                self?.handleLoginSuccess()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private Methods
    private func checkToken() {
        if let token = TokenManager.shared.loadToken(), !token.isEmpty {
            print("Token válido encontrado: \(token)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.state = .navigateToHeroes
            }
        } else {
            print("No se encontró un token válido")
            state = .showLogin
        }
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
    
    private func handleLoginSuccess() {
        isLogged = true
        status = "" // Limpia mensajes de error
        state = .navigateToHeroes
    }
}
