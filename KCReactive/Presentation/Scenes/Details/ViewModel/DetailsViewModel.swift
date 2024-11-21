//
//  DetailsViewModel.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 19/11/24.
//

import Combine
import Foundation

@MainActor
final class DetailsViewModel: ObservableObject {
    
    // MARK: - Propiedades Publicadas
    @Published var transformations: [Transformation]? = nil  // Lista de transformaciones del héroe
    
    // MARK: - Propiedades Públicas
    let hero: Hero  // Héroe cuyos detalles se están mostrando
    
    // MARK: - Propiedades Privadas
    private let transformationUseCase: TransformationUseCaseProtocol  // Caso de uso para obtener transformaciones
    
    // MARK: - Inicializador
    /// Inicializa el ViewModel con el héroe proporcionado y el caso de uso de transformaciones.
    /// - Parameters:
    ///   - hero: Héroe para el cual se mostrarán los detalles.
    ///   - transformationUseCase: Protocolo que define el caso de uso para obtener transformaciones.
    init(
        hero: Hero,
        transformationUseCase: TransformationUseCaseProtocol = TransformationUseCase()
    ) {
        self.hero = hero
        self.transformationUseCase = transformationUseCase
        // Cargar las transformaciones al inicializar
        Task {
            await loadTransformations()
        }
    }
    
    // MARK: - Métodos Públicos
    /// Carga las transformaciones asociadas al héroe.
    func loadTransformations() async {
        do {
            // Intentar obtener las transformaciones mediante el caso de uso
            let fetchedTransformations = try await transformationUseCase.getTransformations(id: hero.id.uuidString)
            // Procesar las transformaciones obtenidas
            let processedTransformations = processTransformations(fetchedTransformations)
            // Asignar las transformaciones procesadas o nil si no hay transformaciones
            self.transformations = processedTransformations.isEmpty ? nil : processedTransformations
        } catch {
            // En caso de error, asignar nil a las transformaciones
            self.transformations = nil
            print("Error al cargar transformaciones: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Métodos Privados
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
        let sortedTransformations = uniqueTransformations.sorted { lhs, rhs in
            lhs.name.compare(rhs.name, options: .numeric) == .orderedAscending
        }
        return sortedTransformations
    }
}
