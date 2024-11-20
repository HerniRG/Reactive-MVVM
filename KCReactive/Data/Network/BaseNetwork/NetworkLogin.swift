// AuthService.swift
// KCReactive
//
// Creado por Hernán Rodríguez el 18/11/24.
//

import Foundation

protocol NetworkLoginProtocol {
    func loginApp(user: String, password: String) async throws -> String
}

final class NetworkLogin: NetworkLoginProtocol {
    func loginApp(user: String, password: String) async throws -> String {
        let urlString = "\(ConstantsApp.CONST_SERVER_URL)\(Endpoints.login.rawValue)"
        let credentials = "\(user):\(password)"
        guard let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() else {
            throw URLError(.badURL)
        }
        
        guard var request = BaseNetwork.createRequest(
            url: urlString,
            httpMethod: HTTPMethods.post,
            requiresAuth: false
        ) else {
            throw URLError(.badURL)
        }
        request.addValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            switch httpResponse.statusCode {
            case HTTPResponseCodes.success:
                // Token decodificado correctamente
                guard let token = String(data: data, encoding: .utf8), !token.isEmpty else {
                    throw URLError(.cannotDecodeContentData)
                }
                return token
            case HTTPResponseCodes.unauthorized:
                throw AuthenticationError.invalidCredentials
            case HTTPResponseCodes.forbidden:
                throw AuthenticationError.accessDenied
            case HTTPResponseCodes.serverErrorRange:
                throw AuthenticationError.serverError(statusCode: httpResponse.statusCode)
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }
}
