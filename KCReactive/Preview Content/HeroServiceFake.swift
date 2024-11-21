//
//  HeroServiceFake.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

enum HeroServiceFakeScenario {
    case success
    case error
    case empty
}

final class HeroServiceFake: HeroServiceProtocol {
    private let scenario: HeroServiceFakeScenario

    init(scenario: HeroServiceFakeScenario) {
        self.scenario = scenario
    }

    func getHeroes(filter: String) async throws -> [Hero] {
        switch scenario {
        case .success:
            // Simular respuesta exitosa con héroes
            let allHeroes = [
                Hero(
                    id: UUID(),
                    name: "Goku",
                    description: "El Saiyan más poderoso.",
                    photo: "https://example.com/goku.jpg",
                    favorite: true,
                    transformations: [
                        Transformation(id: UUID(), name: "Super Saiyan", description: "Primera transformación Saiyan", photo: "https://example.com/super_saiyan.jpg"),
                        Transformation(id: UUID(), name: "Ultra Instinct", description: "La transformación definitiva", photo: "https://example.com/ultra_instinct.jpg")
                    ]
                ),
                Hero(
                    id: UUID(),
                    name: "Vegeta",
                    description: "El príncipe de los Saiyans.",
                    photo: "https://example.com/vegeta.jpg",
                    favorite: false,
                    transformations: [
                        Transformation(id: UUID(), name: "Super Saiyan Blue", description: "Transformación poderosa", photo: "https://example.com/super_saiyan_blue.jpg")
                    ]
                ),
                Hero(
                    id: UUID(),
                    name: "Piccolo",
                    description: "El poderoso guerrero Namekiano.",
                    photo: "https://example.com/piccolo.jpg",
                    favorite: false,
                    transformations: nil
                )
            ]
            
            // Filtrar héroes si se especifica un filtro
            if filter.isEmpty {
                return allHeroes
            } else {
                return allHeroes.filter { $0.name.localizedCaseInsensitiveContains(filter) }
            }

        case .error:
            // Simular un error
            throw URLError(.notConnectedToInternet)

        case .empty:
            // Simular una respuesta vacía
            return []
        }
    }
}
