//
//  TransformationServiceTests.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 25/11/24.
//

import XCTest
@testable import KCReactive

final class TransformationServiceTests: XCTestCase {
    
    
    
    // Test para el servicio fake con éxito
    func testTransformationServiceFakeSuccess() async throws {
        let service = TransformationServiceFake(scenario: .success)
        
        // Simular una ID válida para Goku
        let transformations = try await service.getTransformations(id: "GokuID")
        
        // Verificar el número de transformaciones devueltas
        XCTAssertEqual(transformations.count, 2, "Debería devolver 2 transformaciones para Goku")
        
        // Verificar los nombres de las transformaciones
        XCTAssertEqual(transformations[0].name, "Super Saiyan", "La primera transformación debería ser 'Super Saiyan'")
        XCTAssertEqual(transformations[1].name, "Ultra Instinct", "La segunda transformación debería ser 'Ultra Instinct'")
    }
    
    // Test para el servicio fake con respuesta vacía
    func testTransformationServiceFakeEmpty() async throws {
        let service = TransformationServiceFake(scenario: .empty)
        
        // Simular una ID desconocida
        let transformations = try await service.getTransformations(id: "UnknownID")
        
        // Verificar que no se devuelven transformaciones
        XCTAssertEqual(transformations.count, 0, "No debería devolver transformaciones para una ID desconocida")
    }
}
