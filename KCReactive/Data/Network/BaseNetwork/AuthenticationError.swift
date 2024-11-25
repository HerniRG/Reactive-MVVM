//
//  AuthenticationError.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 18/11/24.
//

import Foundation

enum AuthenticationError: Error {
    case invalidCredentials
    case accessDenied
    case serverError(statusCode: Int)
    case networkError
    case unexpectedError
}
