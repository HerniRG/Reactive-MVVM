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
                let heroes = try JSONDecoder().decode([Hero].self, from: data)
                return heroes
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
