//
//  TransformationServiceFake.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

final class TransformationServiceFake: TransformationServiceProtocol {
    func getTransformations(id: String) async throws -> [Transformation] {
        // Retorna una lista simulada de transformaciones según el ID del héroe
        let allTransformations = [
            Transformation(id: UUID(), name: "Super Saiyan", description: "Primera transformación Saiyan", photo: "https://example.com/super_saiyan.jpg"),
            Transformation(id: UUID(), name: "Ultra Instinct", description: "La transformación definitiva", photo: "https://example.com/ultra_instinct.jpg"),
            Transformation(id: UUID(), name: "Super Saiyan Blue", description: "Transformación poderosa", photo: "https://example.com/super_saiyan_blue.jpg")
        ]
        
        // Simula una lógica de asociación entre héroes y transformaciones
        switch id {
        case "GokuID":
            return allTransformations.filter { $0.name != "Super Saiyan Blue" }
        case "VegetaID":
            return allTransformations.filter { $0.name == "Super Saiyan Blue" }
        default:
            return []
        }
    }
}
