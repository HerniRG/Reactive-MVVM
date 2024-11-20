//
//  TransformationUseCase.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

final class TransformationUseCase: TransformationUseCaseProtocol {
    
    var transformationRepo: TransformationRepositoryProtocol
    
    init(transformationRepo: TransformationRepositoryProtocol = DefaultTransformationRepository(transformationService: TransformationService())) {
        self.transformationRepo = transformationRepo
    }
    
    func getTransformations(id: String) async throws -> [Transformation] {
        do {
            // Llama al repositorio para obtener las transformaciones
            let transformations = try await transformationRepo.getTransformations(id: id)
            return transformations
        } catch {
            // Manejo de errores adicional si es necesario
            throw error
        }
    }
}
