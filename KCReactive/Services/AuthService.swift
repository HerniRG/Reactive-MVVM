//
//  AuthService.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 18/11/24.
//

import Foundation
import Combine

struct AuthService {
    func login(user: String, password: String) -> AnyPublisher<Void, Error> {
        let urlString = "\(server)\(Endpoints.login.rawValue)"
        let credentials = "\(user):\(password)"
        guard let encodedCredentials = credentials.data(using: .utf8)?.base64EncodedString() else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = BaseNetwork.createRequest(
            url: urlString,
            httpMethod: HTTPMethods.post,
            requiresAuth: false
        )
        request?.addValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        
        guard let finalRequest = request else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: finalRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                switch httpResponse.statusCode {
                case 200:
                    // Token decodificado correctamente
                    guard let token = String(data: data, encoding: .utf8), !token.isEmpty else {
                        throw URLError(.cannotDecodeContentData)
                    }
                    TokenManager.shared.saveToken(token)
                case 401:
                    throw AuthenticationError.invalidCredentials
                case 403:
                    throw AuthenticationError.accessDenied
                case 500...599:
                    throw AuthenticationError.serverError(statusCode: httpResponse.statusCode)
                default:
                    throw URLError(.badServerResponse)
                }
            }
            .map { _ in () }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
