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

    /// Obtiene las transformaciones procesadas asociadas al héroe.
    /// - Parameter id: Identificador del héroe.
    /// - Returns: Lista de transformaciones procesadas.
    func getTransformations(id: String) async throws -> [Transformation] {
        do {
            // Llama al repositorio para obtener las transformaciones
            let transformations = try await transformationRepo.getTransformations(id: id)
            return processTransformations(transformations)
        } catch {
            // Propagar el error directamente
            throw error
        }
    }

    /// Procesa las transformaciones eliminando duplicados y ordenándolas numéricamente.
    /// - Parameter transformations: Lista de transformaciones a procesar.
    /// - Returns: Lista de transformaciones procesadas.
    private func processTransformations(_ transformations: [Transformation]) -> [Transformation] {
        // Eliminar duplicados por nombre
        let uniqueTransformations = Array(
            Dictionary(grouping: transformations, by: { $0.name })
                .compactMapValues { $0.first }  // Seleccionar la primera transformación por nombre
                .values
        )
        // Ordenar las transformaciones por nombre numéricamente
        return uniqueTransformations.sorted { lhs, rhs in
            lhs.name.compare(rhs.name, options: .numeric) == .orderedAscending
        }
    }
}

/// `TransformationUseCaseFake` simula `TransformationUseCaseProtocol` para pruebas, devolviendo una lista
/// predefinida de transformaciones.
///
/// - `fakeTransformations`: Incluye "Super Saiyan" y "Ultra Instinct".
/// - `getTransformations(id:)`: Devuelve las transformaciones simuladas.
///
/// Ejemplo:
/// ```
/// let fakeUseCase = TransformationUseCaseFake()
/// let transformations = try await fakeUseCase.getTransformations(id: "GokuID")
/// assert(transformations.count == 2)
/// ```

final class TransformationUseCaseFake: TransformationUseCaseProtocol {
    
    var transformationRepo: any TransformationRepositoryProtocol
    
    /// Lista de transformaciones simuladas.
    private let fakeTransformations: [Transformation] = [
        Transformation(
            id: UUID(),
            name: "Super Saiyan",
            description: "Primera transformación Saiyan.",
            photo: "https://example.com/super_saiyan.jpg"
        ),
        Transformation(
            id: UUID(),
            name: "Ultra Instinct",
            description: "La transformación definitiva.",
            photo: "https://example.com/ultra_instinct.jpg"
        )
    ]
    
    init(transformationRepo: TransformationRepositoryProtocol = DefaultTransformationRepository(transformationService: TransformationService())) {
        self.transformationRepo = transformationRepo
    }

    /// Simula la obtención de transformaciones, devolviendo transformaciones predefinidas.
    func getTransformations(id: String) async throws -> [Transformation] {
        return fakeTransformations
    }
}
