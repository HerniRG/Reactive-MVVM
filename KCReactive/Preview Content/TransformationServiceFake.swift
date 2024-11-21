//
//  TransformationServiceFake.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

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
