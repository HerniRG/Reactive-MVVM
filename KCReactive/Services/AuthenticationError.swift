//
//  AuthenticationError.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 18/11/24.
//

import Foundation

enum AuthenticationError: LocalizedError {
    case invalidCredentials
    case accessDenied
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Usuario o contraseña incorrectos. Verifica tus credenciales."
        case .accessDenied:
            return "No tienes permiso para acceder a este recurso."
        case .serverError(let statusCode):
            return "El servidor encontró un problema (Código: \(statusCode)). Intenta más tarde."
        }
    }
}
