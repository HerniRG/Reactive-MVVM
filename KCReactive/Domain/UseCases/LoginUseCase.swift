//
//  LoginUseCase.swift
//  KCReactive
//
//  Created por Hernán Rodríguez el 20/11/24.
//

import Foundation

final class LoginUseCase: LoginUseCaseProtocol {
    
    var repo: LoginRepositoryProtocol
    
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(network: NetworkLogin())) {
        self.repo = repo
    }

    /// Realiza el login de usuario y almacena el token si es exitoso.
    func loginApp(user: String, password: String) async throws -> Bool {
        // Simplemente delega al repositorio y guarda el token si el login tiene éxito
        let token = try await repo.login(user: user, password: password)
        TokenManager.shared.saveToken(token)
        return true
    }

    /// Verifica si existe un token válido almacenado.
    func checkToken() -> Bool {
        if let token = TokenManager.shared.loadToken(), !token.isEmpty {
            return true
        } else {
            return false
        }
    }
}

/// `LoginUseCaseFake` es una implementación simulada del protocolo `LoginUseCaseProtocol`,
/// diseñada para pruebas unitarias o de integración. Simula el comportamiento del caso de uso
/// de login, permitiendo emular un flujo exitoso sin depender de un backend real.
///
/// - `loginApp(user:password:)`: Simula un login exitoso y guarda un token ficticio ("LoginFakeSuccess")
///   en el `TokenManager`, devolviendo siempre `true`.
/// - `checkToken()`: Simula la existencia de un token válido, devolviendo siempre `true`.
///
/// Uso típico:
/// ```
/// let fakeUseCase = LoginUseCaseFake()
/// let loginResult = try await fakeUseCase.loginApp(user: "testUser", password: "testPass")
/// assert(loginResult == true) // Simula un login exitoso
/// assert(fakeUseCase.checkToken() == true) // Simula que hay un token válido
/// ```

final class LoginUseCaseFake: LoginUseCaseProtocol {
    
    var repo: LoginRepositoryProtocol
    
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(network: NetworkLogin())) {
        self.repo = repo
    }

    /// Realiza el login de usuario y almacena el token si es exitoso.
    func loginApp(user: String, password: String) async throws -> Bool {
        TokenManager.shared.saveToken("LoginFakeSuccess")
        return true
    }

    /// Verifica si existe un token válido almacenado.
    func checkToken() -> Bool {
        return true
    }
}
