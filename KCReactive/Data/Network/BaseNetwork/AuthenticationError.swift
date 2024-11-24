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
    case networkError
    case unexpectedError
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return NSLocalizedString("InvalidCredentials", comment: "Invalid credentials error")
        case .accessDenied:
            return NSLocalizedString("AccessDenied", comment: "Access denied error")
        case .serverError(let statusCode):
            return String(format: NSLocalizedString("ServerError", comment: "Server error with code"), statusCode)
        case .networkError:
            return NSLocalizedString("NetworkError", comment: "Network connectivity error")
        case .unexpectedError:
            return NSLocalizedString("UnexpectedError", comment: "Unexpected error")
        }
    }
}
