//
//  TransformationRepository.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 20/11/24.
//

import Foundation

final class DefaultTransformationRepository: TransformationRepositoryProtocol {
    
    private var transformationService: TransformationServiceProtocol
    
    init(transformationService: TransformationServiceProtocol) {
        self.transformationService = transformationService
    }
    
    func getTransformations(id: String) async throws -> [Transformation] {
        return try await transformationService.getTransformations(id: id)
    }
}

final class TransformationRepositoryFake: TransformationRepositoryProtocol {
    
    private var transformationService: TransformationServiceProtocol
    
    init(transformationService: TransformationServiceProtocol) {
        self.transformationService = transformationService
    }
    
    func getTransformations(id: String) async throws -> [Transformation] {
        return try await transformationService.getTransformations(id: id)
    }
}
