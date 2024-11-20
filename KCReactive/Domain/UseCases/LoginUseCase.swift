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

    func loginApp(user: String, password: String) async throws -> Bool {
        do {
            // Obtiene el token llamando al repositorio
            let token = try await repo.login(user: user, password: password)
            
            // Guarda el token en el TokenManager
            TokenManager.shared.saveToken(token)
            return true
        } catch {
            // Manejo de errores adicional si es necesario
            throw error
        }
    }
}
