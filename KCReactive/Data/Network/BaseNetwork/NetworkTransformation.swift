//
//  NetworkTransformaciones.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

protocol TransformationServiceProtocol {
    func getTransformations(id: String) async throws -> [Transformation]
}

final class TransformationService: TransformationServiceProtocol {
    func getTransformations(id: String) async throws -> [Transformation] {
        let urlString = "\(ConstantsApp.CONST_SERVER_URL)\(Endpoints.transformationsList.rawValue)"
        
        // Crear la solicitud usando BaseNetwork
        guard let request = BaseNetwork.createRequest(
            url: urlString,
            httpMethod: HTTPMethods.post,
            body: TransformationFilter(id: id)
        ) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            switch httpResponse.statusCode {
            case HTTPResponseCodes.success:
                // Decodificar la respuesta
                let transformations = try JSONDecoder().decode([Transformation].self, from: data)
                return transformations
            case HTTPResponseCodes.unauthorized:
                throw AuthenticationError.invalidCredentials
            case HTTPResponseCodes.serverErrorRange:
                throw AuthenticationError.serverError(statusCode: httpResponse.statusCode)
            default:
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error // Propagar errores encontrados
        }
    }
}

/// `TransformationServiceFake` es una clase que implementa el protocolo `TransformationServiceProtocol` y permite simular diferentes respuestas al obtener transformaciones.
/// Es útil para pruebas unitarias y de integración, ya que emula distintos escenarios sin depender de un backend real.
///
/// - `scenario`: Define el caso a simular utilizando el enum `TransformationServiceFakeScenario`.
///   - `.success`: Devuelve una lista de transformaciones simuladas dependiendo del ID proporcionado.
///   - `.empty`: Simula una respuesta vacía, indicando que no hay transformaciones disponibles.
///   - `.error`: Simula un error de red.
///   - `.delayedSuccess`: Simula un retraso en la respuesta antes de devolver transformaciones simuladas.
///
/// Ejemplo de uso:
/// ```
/// let fakeTransformationService = TransformationServiceFake(scenario: .success)
/// let transformations = try await fakeTransformationService.getTransformations(id: "GokuID")
/// print(transformations) // Devuelve transformaciones simuladas según el ID proporcionado.
/// ```

enum TransformationServiceFakeScenario {
    case success
    case empty
    case error
    case delayedSuccess
}

final class TransformationServiceFake: TransformationServiceProtocol {
    private let scenario: TransformationServiceFakeScenario

    init(scenario: TransformationServiceFakeScenario) {
        self.scenario = scenario
    }

    func getTransformations(id: String) async throws -> [Transformation] {
        switch scenario {
        case .success:
            // Retorna transformaciones simuladas según el ID
            let allTransformations = [
                Transformation(id: UUID(), name: "Super Saiyan", description: "Primera transformación Saiyan", photo: "https://example.com/super_saiyan.jpg"),
                Transformation(id: UUID(), name: "Ultra Instinct", description: "La transformación definitiva", photo: "https://example.com/ultra_instinct.jpg"),
                Transformation(id: UUID(), name: "Super Saiyan Blue", description: "Transformación poderosa", photo: "https://example.com/super_saiyan_blue.jpg")
            ]
            
            switch id {
            case "GokuID":
                return allTransformations.filter { $0.name != "Super Saiyan Blue" }
            case "VegetaID":
                return allTransformations.filter { $0.name == "Super Saiyan Blue" }
            default:
                return []
            }
        
        case .empty:
            // Simula una respuesta vacía
            return []
        
        case .error:
            // Simula un error
            throw URLError(.notConnectedToInternet)
        
        case .delayedSuccess:
            // Simula un retraso antes de devolver las transformaciones
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 segundos
            return [
                Transformation(id: UUID(), name: "Super Saiyan", description: "Primera transformación Saiyan", photo: "https://example.com/super_saiyan.jpg"),
                Transformation(id: UUID(), name: "Ultra Instinct", description: "La transformación definitiva", photo: "https://example.com/ultra_instinct.jpg")
            ]
        }
    }
}
