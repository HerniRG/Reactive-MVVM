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
    @Published var transformations: [Transformation]? = nil

    // MARK: - Propiedades Públicas
    let hero: Hero

    // MARK: - Propiedades Privadas
    private let transformationUseCase: TransformationUseCaseProtocol

    // MARK: - Inicializador
    init(
        hero: Hero,
        transformationUseCase: TransformationUseCaseProtocol = TransformationUseCase()
    ) {
        self.hero = hero
        self.transformationUseCase = transformationUseCase
        
        Task {
            await loadTransformations()
        }
    }

    // MARK: - Métodos Públicos
    /// Carga las transformaciones asociadas al héroe.
    func loadTransformations() async {
        do {
            // Obtener las transformaciones procesadas mediante el caso de uso
            let fetchedTransformations = try await transformationUseCase.getTransformations(id: hero.id.uuidString)
            self.transformations = fetchedTransformations.isEmpty ? nil : fetchedTransformations
        } catch {
            // En caso de error, asignar nil a las transformaciones
            self.transformations = nil
        }
    }
}
