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
