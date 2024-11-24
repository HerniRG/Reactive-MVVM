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
            throw AuthenticationError.unexpectedError
        }
        
        guard var request = BaseNetwork.createRequest(
            url: urlString,
            httpMethod: HTTPMethods.post,
            requiresAuth: false
        ) else {
            throw AuthenticationError.unexpectedError
        }
        request.addValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthenticationError.unexpectedError
            }

            switch httpResponse.statusCode {
            case HTTPResponseCodes.success:
                guard let token = String(data: data, encoding: .utf8), !token.isEmpty else {
                    throw AuthenticationError.serverError(statusCode: 500)
                }
                return token
            case HTTPResponseCodes.unauthorized:
                throw AuthenticationError.invalidCredentials
            case HTTPResponseCodes.forbidden:
                throw AuthenticationError.accessDenied
            case HTTPResponseCodes.serverErrorRange:
                throw AuthenticationError.serverError(statusCode: httpResponse.statusCode)
            default:
                throw AuthenticationError.unexpectedError
            }
        } catch let error as AuthenticationError {
            throw error
        } catch _ as URLError {
            throw AuthenticationError.networkError
        } catch {
            throw AuthenticationError.unexpectedError
        }
    }
}

/// `NetworkLoginFake` es una clase que implementa el protocolo `NetworkLoginProtocol` y proporciona una simulación de respuestas para escenarios de login.
/// Permite emular diferentes situaciones, como éxito en la autenticación, credenciales inválidas, errores del servidor o problemas de red.
/// Esto es especialmente útil para realizar pruebas unitarias y de integración sin necesidad de depender de un backend real.
///
/// - `scenario`: Define el caso que se desea simular utilizando el enum `NetworkLoginFakeScenario`.
///
/// Ejemplo de uso:
/// ```
/// let fakeLogin = NetworkLoginFake(scenario: .success)
/// let token = try await fakeLogin.loginApp(user: "test", password: "password")
/// print(token) // Devuelve un token simulado en caso de éxito.
/// ```

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
            throw AuthenticationError.invalidCredentials
        case .serverError:
            throw AuthenticationError.serverError(statusCode: 500)
        case .networkError:
            throw AuthenticationError.networkError
        }
    }
}
