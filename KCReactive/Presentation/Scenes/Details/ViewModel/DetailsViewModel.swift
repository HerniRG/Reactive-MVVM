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
    var heroe: Hero
    @Published var transformations: [Transformation]? = nil
    @Published var hasTransformations : Bool = false
    
    private var heroService = HeroService()
    
    init(heroe: Hero, heroService: HeroService = HeroService()) {
        self.heroe = heroe
        self.heroService = heroService
        Task {
            await loadTransformations()
        }
    }
    
    // MARK: - Methods
    func loadTransformations() async {
        do {
            // Llamar al servicio para obtener transformaciones
            let fetchedTransformations = try await heroService.getTransformations(id: heroe.id.uuidString)
            self.transformations = processTransformations(fetchedTransformations)
            self.hasTransformations = !fetchedTransformations.isEmpty
            print(fetchedTransformations)
            print(self.hasTransformations)
        } catch {
            self.hasTransformations = false
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
