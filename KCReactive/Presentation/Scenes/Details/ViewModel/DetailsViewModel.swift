//
//  DetailsViewModel.swift
//  KCReactive
//
//  Created by Hernán Rodríguez on 19/11/24.
//

import Combine
import Foundation
import Hero

@MainActor
final class DetailsViewModel: ObservableObject {
    var heroe: Hero
    @Published var transformations: [Transformation]? = nil
    
    private var transformationUseCase: TransformationUseCaseProtocol
    
    init(
        heroe: Hero,
        transformationUseCase: TransformationUseCaseProtocol = TransformationUseCase()
    ) {
        self.heroe = heroe
        self.transformationUseCase = transformationUseCase
        Task {
            await loadTransformations()
        }
    }
    
    func loadTransformations() async {
        do {
            let fetchedTransformations = try await transformationUseCase.getTransformations(id: heroe.id.uuidString)
            let processedTransformations = processTransformations(fetchedTransformations)
            self.transformations = processedTransformations.isEmpty ? nil : processedTransformations
        } catch {
            self.transformations = nil
        }
    }
    
    private func processTransformations(_ transformations: [Transformation]) -> [Transformation] {
        // Eliminar duplicados por nombre y ordenar numéricamente
        let uniqueTransformations = Array(
            Dictionary(grouping: transformations, by: { $0.name })
                .compactMapValues { $0.first } // Seleccionamos la primera transformación por nombre
                .values
        )
        // Ordenar las transformaciones por nombre numéricamente
        return uniqueTransformations.sorted { lhs, rhs in
            lhs.name.compare(rhs.name, options: .numeric) == .orderedAscending
        }
    }
}
