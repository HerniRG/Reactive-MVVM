//
//  NetworkHeroe.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

protocol HeroServiceProtocol {
    func getHeroes(filter: String) async throws -> [Hero]
}

final class HeroService: HeroServiceProtocol {
    func getHeroes(filter: String) async throws -> [Hero] {
        let urlString = "\(ConstantsApp.CONST_SERVER_URL)\(Endpoints.heroesList.rawValue)"
        
        // Crear la solicitud usando BaseNetwork
        guard let request = BaseNetwork.createRequest(
            url: urlString,
            httpMethod: HTTPMethods.post,
            body: HeroFilter(name: filter)
        ) else {
            throw AuthenticationError.unexpectedError
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AuthenticationError.unexpectedError
            }
            
            switch httpResponse.statusCode {
            case HTTPResponseCodes.success:
                // Decodificar la respuesta
                let heroes = try JSONDecoder().decode([Hero].self, from: data)
                return heroes
            case HTTPResponseCodes.unauthorized:
                throw AuthenticationError.invalidCredentials
            case HTTPResponseCodes.serverErrorRange:
                throw AuthenticationError.serverError(statusCode: httpResponse.statusCode)
            default:
                throw AuthenticationError.unexpectedError
            }
        } catch _ as URLError {
            throw AuthenticationError.networkError
        } catch {
            throw AuthenticationError.unexpectedError
        }
    }
}

/// `HeroServiceFake` es una clase que implementa el protocolo `HeroServiceProtocol` y permite simular diferentes respuestas al obtener héroes.
/// Facilita las pruebas unitarias y de integración al emular escenarios específicos sin realizar llamadas reales a servicios de red.
///
/// - `scenario`: Define el caso que se desea simular utilizando el enum `HeroServiceFakeScenario`.
///   - `.success`: Devuelve una lista de héroes simulados, con la posibilidad de filtrarlos por nombre.
///   - `.error`: Simula un error de red.
///   - `.empty`: Devuelve una lista vacía para simular la ausencia de resultados.
///
/// Ejemplo de uso:
/// ```
/// let fakeHeroService = HeroServiceFake(scenario: .success)
/// let heroes = try await fakeHeroService.getHeroes(filter: "Goku")
/// print(heroes) // Devuelve héroes simulados que coincidan con el filtro.
/// ```

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
                    favorite: true
                ),
                Hero(
                    id: UUID(),
                    name: "Vegeta",
                    description: "El príncipe de los Saiyans.",
                    photo: "https://example.com/vegeta.jpg",
                    favorite: false
                ),
                Hero(
                    id: UUID(),
                    name: "Piccolo",
                    description: "El poderoso guerrero Namekiano.",
                    photo: "https://example.com/piccolo.jpg",
                    favorite: false
                )
            ]
            
            // Filtrar héroes si se especifica un filtro
            if filter.isEmpty {
                return allHeroes
            } else {
                return allHeroes.filter { $0.name.localizedCaseInsensitiveContains(filter) }
            }

        case .error:
            throw AuthenticationError.networkError

        case .empty:
            return []
        }
    }
}
