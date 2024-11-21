//
//  NetworkLoginFake.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

enum NetworkLoginFakeScenario {
    case success
    case invalidCredentials
    case serverError
    case networkError
}

final class NetworkLoginFake: NetworkLoginProtocol {
    private let scenario: NetworkLoginFakeScenario

    init(scenario: NetworkLoginFakeScenario) {
        self.scenario = scenario
    }

    func loginApp(user: String, password: String) async throws -> String {
        switch scenario {
        case .success:
            // Simular un login exitoso
            return "eyJraWQiOiJwcml2YXRlIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJleHBpcmF0aW9uIjo2NDA5MjIxMTIwMCwiaWRlbnRpZnkiOiI0MURCRTlGNy04MzVFLTQ1RkUtOTJBMi1CMDI5NUNCN0E5QjgiLCJlbWFpbCI6Imhlcm5hbnJnODVAZ21haWwuY29tIn0.oBNMWqw0n8SBpf36ls8rFQijukSrURkzyXO2qXW6rS8"

        case .invalidCredentials:
            // Simular credenciales inválidas
            throw AuthenticationError.invalidCredentials

        case .serverError:
            // Simular un error del servidor
            throw AuthenticationError.serverError(statusCode: 500)

        case .networkError:
            // Simular un error de red
            throw URLError(.notConnectedToInternet)
        }
    }
}
