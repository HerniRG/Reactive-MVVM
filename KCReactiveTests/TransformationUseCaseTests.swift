//
//  TransformationUseCaseTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 26/11/24.
//

import XCTest
@testable import KCReactive

final class TransformationUseCaseTests: XCTestCase {

    func testTransformationUseCaseWithFakeRepository() async throws {
        // Configurar el TransformationRepositoryFake con un servicio simulado
        let fakeRepository = TransformationRepositoryFake(
            transformationService: TransformationServiceFake(scenario: .success)
        )
        
        // Crear el TransformationUseCase usando el repositorio falso
        let useCase = TransformationUseCase(transformationRepo: fakeRepository)
        XCTAssertNotNil(useCase, "TransformationUseCase debería ser inicializable")

        // Ejecutar el caso de uso para obtener transformaciones
        let transformations = try await useCase.getTransformations(id: "GokuID")
        XCTAssertNotNil(transformations, "La respuesta de transformaciones no debería ser nil")
        
        // Verificar que las transformaciones procesadas sean correctas
        XCTAssertEqual(transformations.count, 2, "Debería haber 2 transformaciones después de procesarlas")
        
        // Verificar el orden de las transformaciones
        XCTAssertEqual(transformations[0].name, "Super Saiyan", "La primera transformación debería ser 'Super Saiyan'")
        XCTAssertEqual(transformations[1].name, "Ultra Instinct", "La segunda transformación debería ser 'Ultra Instinct'")
    }
}
